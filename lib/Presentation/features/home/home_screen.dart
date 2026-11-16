import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskly/Core/app_colors.dart';
import 'package:taskly/Core/app_strings.dart';
import 'package:taskly/Presentation/features/home/widgets/app_logo.dart';
import 'package:taskly/Presentation/features/home/widgets/filtter_button.dart';
import 'package:taskly/Presentation/features/home/widgets/profile_avatar.dart';
import 'package:taskly/Presentation/features/home/widgets/stat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = AppStrings.all;

  void onFilterTap(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          spacing: 12,
          children: [
            AppLogo(),
            Text(AppStrings.appName, style: TextStyle(fontWeight: .bold)),
          ],
        ),
        actions: [
          Padding(padding: const EdgeInsets.all(8.0), child: ProfileAvatar()),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.goodMorning,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.labelText,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              AppStrings.userName,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            Row(
              spacing: 7,
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.list,
                    count: 2,
                    status: AppStrings.total,
                    iconColor: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: StatCard(
                    icon: Icons.schedule_outlined,
                    count: 2,
                    status: AppStrings.pending,
                    iconColor: AppColors.amberIcon,
                  ),
                ),
                Expanded(
                  child: StatCard(
                    icon: Icons.list,
                    count: 2,
                    status: AppStrings.completed,
                    iconColor: AppColors.greenIcon,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Row(
              spacing: 5,
              children: [
                FilterButton(
                  status: AppStrings.all,
                  isSelected: selectedFilter == AppStrings.all,
                  onTap: () => onFilterTap(AppStrings.all),
                ),
                FilterButton(
                  status: AppStrings.pending,
                  isSelected: selectedFilter == AppStrings.pending,
                  onTap: () => onFilterTap(AppStrings.pending),
                ),
                FilterButton(
                  status: AppStrings.completed,
                  isSelected: selectedFilter == AppStrings.completed,
                  onTap: () => onFilterTap(AppStrings.completed),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
