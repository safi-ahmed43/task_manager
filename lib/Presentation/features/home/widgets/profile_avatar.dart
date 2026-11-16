import 'package:flutter/cupertino.dart';
import 'package:taskly/Core/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(30),
        borderRadius: BorderRadius.circular(50),
      ),
      alignment: Alignment.center,
      child: Text('S',style: TextStyle(color: AppColors.primary,fontWeight: .w800,fontSize: 18),),
    );
  }
}
