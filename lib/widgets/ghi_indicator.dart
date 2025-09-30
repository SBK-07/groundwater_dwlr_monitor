import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GHIIndicator extends StatelessWidget {
  final String location;
  final double ghiScore; // out of 100

  const GHIIndicator({
    super.key,
    required this.location,
    required this.ghiScore,
  });

  String get status {
    if (ghiScore >= 70) return "Good";
    if (ghiScore >= 40) return "Moderate";
    return "Poor";
  }

  Color get statusColor {
    if (ghiScore >= 70) return Colors.green;
    if (ghiScore >= 40) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    const double minScore = 0.0;
    const double maxScore = 100.0;

    // normalize 0–100 → 0–1
    final double normalized = (ghiScore - minScore) / (maxScore - minScore);
    final double clamped = normalized.clamp(0.0, 1.0);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Groundwater Level",
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
                        colors: [Colors.red, Colors.orange, Colors.green],
                        stops: [0.0, 0.4, 1.0],
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

            // Score & Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${ghiScore.toStringAsFixed(0)} / 100",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                Text(location,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

