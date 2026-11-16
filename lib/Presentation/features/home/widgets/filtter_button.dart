import 'package:flutter/cupertino.dart';
import 'package:taskly/Core/app_colors.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key, required this.status, required this.isSelected, required this.onTap});

  final bool isSelected;
  final VoidCallback onTap;

  final String status;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.bodyText
          )
        ),
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: .center,
        child: Text(
          status,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.white:AppColors.bodyText,
          ),
        ),
      ),
    );
  }
}
