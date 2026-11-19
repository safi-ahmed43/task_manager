import 'package:flutter/material.dart';
import 'package:taskly/Core/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Icon(Icons.note_alt, color: AppColors.background, size: 24),
    );
  }
}
