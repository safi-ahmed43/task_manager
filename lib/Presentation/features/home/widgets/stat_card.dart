import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskly/Core/app_colors.dart';

class StatCard extends StatelessWidget {

  const StatCard({super.key, required this.icon, required this.count, required this.status, required this.iconColor});
  final IconData icon;
  final int count;
  final String status;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: AppColors.cardShadow,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12,top: 10,bottom: 10,right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Icon(icon,size: 28,color: iconColor,),
            Text(count.toString(),style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),),
            Text(status,style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.labelText
            ),)

          ],
        ),
      ),
    );
  }
}
