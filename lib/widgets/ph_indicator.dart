import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PHIndicator extends StatelessWidget {
  final double phValue;

  const PHIndicator({super.key, required this.phValue});

  String get status {
    if (phValue >= 6.5 && phValue <= 8.5) return "Drinkable";
    if (phValue < 6.5) return "Acidic Hazard";
    return "Alkaline Hazard";
  }

  Color get statusColor {
    if (phValue >= 6.5 && phValue <= 8.5) return Colors.green;
    if (phValue < 6.5) return Colors.redAccent;
    return Colors.deepOrange;
  }

  @override
  Widget build(BuildContext context) {
    const double minPH = 0.0;
    const double maxPH = 14.0;

    // normalize ph to 0–1 range
    final double normalized = (phValue - minPH) / (maxPH - minPH);
    final double clamped = normalized.clamp(0.0, 1.0);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "GroundWater Health",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[900],
              ),
            ),
            const SizedBox(height: 12),

            // Bar with arrow pointer
            SizedBox(
              height: 30,
              child: Stack(
                children: [
                  // Gradient bar
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Colors.red, Colors.green, Colors.orange, Colors.red],
                        stops: [0.0, 0.45, 0.55, 1.0],
                      ),
                    ),
                  ),

                  // Arrow indicator
                  Align(
                    alignment: Alignment(clamped * 2 - 1, 0), // map 0–1 → -1–1
                    child: const Icon(Icons.arrow_drop_up, size: 28, color: Colors.black),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // pH Value and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(status,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}