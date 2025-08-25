import 'package:flutter/material.dart';

class GradientTitle extends StatelessWidget {
  const GradientTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.white, Color(0xFFB0BEC5)], // White to light grey
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: const Text(
        'CIMA Optimizer',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
    );
  }
}
