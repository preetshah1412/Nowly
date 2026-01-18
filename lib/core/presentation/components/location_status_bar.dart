import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationStatusBar extends StatelessWidget {
  final String location;
  final bool isPrecise;

  const LocationStatusBar({
    super.key,
    this.location = "Finding your location...",
    this.isPrecise = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .fadeIn(duration: 500.ms)
              .fadeOut(delay: 500.ms),
          const SizedBox(width: 8),
          Text(
            location,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          if (isPrecise) ...[
            const SizedBox(width: 4),
            const Icon(Icons.check_circle_rounded,
                size: 14, color: Colors.blue),
          ]
        ],
      ),
    );
  }
}
