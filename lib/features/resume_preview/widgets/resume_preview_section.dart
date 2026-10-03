import 'package:flutter/material.dart';

class ResumePreviewSection
    extends StatelessWidget {
  const ResumePreviewSection({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const primary =
    Color(0xFF24348F);

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.9,
            color: primary,
          ),
        ),

        const SizedBox(height: 5),

        Container(
          height: 1.2,
          width: double.infinity,
          color: primary,
        ),

        const SizedBox(height: 10),

        child,

        const SizedBox(height: 18),
      ],
    );
  }
}