import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class SOSButton extends StatefulWidget {
  final VoidCallback onPressed;

  const SOSButton({super.key, required this.onPressed});

  @override
  State<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        HapticFeedback.heavyImpact();
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing Rings
            for (int i = 0; i < 3; i++)
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.3 - (i * 0.1)),
                    width: 2,
                  ),
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.3, 1.3),
                    duration: (2 + i).seconds,
                    curve: Curves.easeOut,
                  )
                  .fadeOut(duration: (2 + i).seconds),

            // Main Button Shadow
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withOpacity(0.2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.red,
                    blurRadius: 20,
                    spreadRadius: 0,
                  )
                ],
              ) as Decoration?,
            ),

            // The Button
            AnimatedContainer(
              duration: 100.ms,
              width: _isPressed ? 160 : 170,
              height: _isPressed ? 160 : 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFE63946), Color(0xFFD00000)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: _isPressed ? 10 : 30,
                    spreadRadius: _isPressed ? 1 : 5,
                    offset:
                        _isPressed ? const Offset(0, 5) : const Offset(0, 15),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.sos_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                    Text(
                      'SOS',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                    Text(
                      'HOLD 3S',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
