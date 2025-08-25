import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final double value; // A value between 0.0 and 1.0
  final String metricLabel;
  final Color color;

  const ProgressCard({
    super.key,
    required this.title,
    required this.value,
    required this.metricLabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 12,
                    backgroundColor: color.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  metricLabel,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
