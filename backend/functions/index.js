const functions = require('firebase-functions');
const admin = require('firebase-admin');
const geofire = require('geofire-common');
admin.initializeApp();

function haversineKm(a, b) {
  const R = 6371;
  const dLat = (b.lat - a.lat) * Math.PI / 180;
  const dLon = (b.lng - a.lng) * Math.PI / 180;
  const lat1 = a.lat * Math.PI / 180;
  const lat2 = b.lat * Math.PI / 180;
  const s = Math.sin(dLat / 2) ** 2 + Math.sin(dLon / 2) ** 2 * Math.cos(lat1) * Math.cos(lat2);
  return 2 * R * Math.asin(Math.sqrt(s));
}

async function sendFcmToProvider(providerId, payload) {
  const tokensSnap = await admin.firestore().collection('providers').doc(providerId).collection('tokens').get();
  const tokens = tokensSnap.docs.map(d => d.data().fcmToken).filter(Boolean);
  if (tokens.length === 0) return;
  await admin.messaging().sendMulticast({ tokens, data: payload });
}

exports.onProviderWrite = functions.firestore.document('providers/{uid}').onWrite(async (change, ctx) => {
  const after = change.after.exists ? change.after.data() : null;
  if (!after) return;
  const loc = after.location;
  if (!loc) return;
  const geohash = geofire.geohashForLocation([loc.latitude, loc.longitude]);
  await change.after.ref.set({ geohash }, { merge: true });
});

exports.onServiceRequestCreate = functions.firestore.document('service_requests/{requestId}').onCreate(async (snap, ctx) => {
  const req = snap.data();
  const center = [req.location.latitude, req.location.longitude];
  const radiusKm = req.urgency === 'immediate' ? 6 : req.urgency === 'same_day' ? 15 : 30;
  const bounds = geofire.geohashQueryBounds(center, radiusKm * 1000);
  const providersRef = admin.firestore().collection('providers');
  const candidates = [];
  for (const b of bounds) {
    const q = providersRef.where('availability', '==', true).where('serviceCategories', 'array-contains', req.category).orderBy('geohash').startAt(b[0]).endAt(b[1]);
    const snapProv = await q.get();
    for (const doc of snapProv.docs) {
      const p = doc.data();
      const km = haversineKm({ lat: req.location.latitude, lng: req.location.longitude }, { lat: p.location.latitude, lng: p.location.longitude });
      if (km <= radiusKm) {
        candidates.push({ id: doc.id, distanceKm: km, reliabilityScore: (p.stats && p.stats.reliabilityScore) || 0 });
      }
    }
  }
  candidates.sort((a, b) => a.distanceKm - b.distanceKm || b.reliabilityScore - a.reliabilityScore);
  const top = candidates.slice(0, 10).map(c => c.id);
  await snap.ref.update({ providerCandidates: top });
  await Promise.all(top.map(id => sendFcmToProvider(id, { type: 'new_request', requestId: ctx.params.requestId })));
});

exports.acceptRequest = functions.https.onCall(async (data, context) => {
  const providerId = context.auth && context.auth.uid;
  const requestId = data.requestId;
  if (!providerId || !requestId) throw new functions.https.HttpsError('failed-precondition', 'invalid');
  const reqRef = admin.firestore().collection('service_requests').doc(requestId);
  await admin.firestore().runTransaction(async tx => {
    const doc = await tx.get(reqRef);
    if (!doc.exists) throw new functions.https.HttpsError('not-found', 'missing');
    const req = doc.data();
    if (req.status !== 'pending') throw new functions.https.HttpsError('failed-precondition', 'closed');
    if (!(req.providerCandidates || []).includes(providerId)) throw new functions.https.HttpsError('permission-denied', 'not-invited');
    tx.update(reqRef, { status: 'accepted', acceptedBy: providerId, acceptTimestamp: admin.firestore.FieldValue.serverTimestamp() });
  });
  const userId = (await reqRef.get()).data().userId;
  const userTokens = await admin.firestore().collection('users').doc(userId).collection('tokens').get();
  const tokens = userTokens.docs.map(d => d.data().fcmToken).filter(Boolean);
  if (tokens.length) await admin.messaging().sendMulticast({ tokens, data: { type: 'request_accepted', requestId } });
  return { ok: true };
});

exports.autoExpireRequests = functions.pubsub.schedule('* * * * *').onRun(async () => {
  const now = admin.firestore.Timestamp.now();
  const q = await admin.firestore().collection('service_requests').where('status', '==', 'pending').where('expiresAt', '<=', now).get();
  const batch = admin.firestore().batch();
  q.docs.forEach(d => batch.update(d.ref, { status: 'expired' }));
  await batch.commit();
});

exports.onJobConfirmed = functions.firestore.document('service_requests/{requestId}').onUpdate(async (change, ctx) => {
  const before = change.before.data();
  const after = change.after.data();
  if (before.status !== 'accepted' || after.status !== 'completed') return;
  const providerId = after.acceptedBy;
  if (!providerId) return;
  const provRef = admin.firestore().collection('providers').doc(providerId);
  await admin.firestore().runTransaction(async tx => {
    const pdoc = await tx.get(provRef);
    const p = pdoc.data() || {};
    const stats = p.stats || {};
    const total = (stats.completedJobsTotal || 0) + 1;
    const urgent = (stats.completedUrgentJobs || 0) + (after.urgency === 'immediate' ? 1 : 0);
    const reliability = Math.min(1, urgent / Math.max(1, total));
    tx.update(provRef, { stats: { completedJobsTotal: total, completedUrgentJobs: urgent, reliabilityScore: reliability } });
  });
});
