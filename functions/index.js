const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { GeoFirestore } = require("geofirestore");

admin.initializeApp();
const db = admin.firestore();

// Create a GeoFirestore reference
const geofirestore = new GeoFirestore(db);
const providersGeo = geofirestore.collection("providers");

/**
 * Triggered when a new Service Request is created.
 * Matches available providers and sends notifications.
 */
exports.matchProviders = functions.firestore
  .document("service_requests/{requestId}")
  .onCreate(async (snap, context) => {
    const request = snap.data();
    const requestId = context.params.requestId;

    if (!request.location || !request.category) return;

    const center = request.location; // GeoPoint
    const radius = 5; // 5km search radius

    try {
      // 1. Query for providers within radius
      const query = providersGeo.near({
        center: center,
        radius: radius,
      });

      const snapshot = await query.get();
      let candidates = [];

      snapshot.forEach((doc) => {
        const data = doc.data();
        // Additional Filters (Availability & Category)
        // Note: GeoFirestore filters by location, we must filter others manually 
        // if not using composite indexes supported by the library.
        if (data.is_available && data.service_category === request.category) {
          candidates.push({
            id: doc.id,
            ...data,
            distance: doc.distance, // Provided by GeoFirestore
          });
        }
      });

      if (candidates.length === 0) {
        console.log(`No providers found for request ${requestId}`);
        await snap.ref.update({ status: "no_providers_found" });
        return;
      }

      // 2. Ranking Logic
      // Sort by Availability (Already Checked) -> Distance -> Reliability
      candidates.sort((a, b) => {
        // Priority: Reliability Score (Desc)
        // If reliability is similar (within 0.5), prioritize distance
        const scoreDiff = b.reliability_score - a.reliability_score;
        if (Math.abs(scoreDiff) < 0.5) {
            return a.distance - b.distance; // Ascending distance
        }
        return scoreDiff;
      });

      // 3. Send Notifications to Top 5
      const topCandidates = candidates.slice(0, 5);
      const tokens = topCandidates.map(c => c.fcm_token).filter(t => t);

      if (tokens.length > 0) {
        await admin.messaging().sendMulticast({
          tokens: tokens,
          data: {
            jobId: requestId,
            type: "NEW_JOB",
            urgency: request.urgency,
          },
          notification: {
            title: "New Urgent Job Nearby!",
            body: `${request.category.toUpperCase()} needed. ${candidates[0].distance.toFixed(1)}km away.`,
          },
        });
        
        console.log(`Notified ${tokens.length} providers.`);
      }

    } catch (error) {
      console.error("Error matching providers:", error);
    }
  });

/**
 * Scheduled function to expire pending requests older than 30 mins.
 * Run every 5 minutes.
 */
exports.expireRequests = functions.pubsub.schedule("every 5 minutes").onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const cutoff = new Date(now.toDate().getTime() - 30 * 60 * 1000); // 30 mins ago

    const snapshot = await db.collection("service_requests")
        .where("status", "==", "pending")
        .where("created_at", "<", cutoff)
        .get();

    const batch = db.batch();
    snapshot.docs.forEach((doc) => {
        batch.update(doc.ref, { status: "expired" });
    });

    await batch.commit();
    console.log(`Expired ${snapshot.size} old requests.`);
});
