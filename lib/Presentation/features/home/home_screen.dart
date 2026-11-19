import 'package:flutter/material.dart';
import 'package:taskly/Presentation/features/home/widgets/app_logo.dart';
import 'package:taskly/Presentation/features/home/widgets/empty_tast_view.dart';
import 'package:taskly/Presentation/features/home/widgets/filtter_button.dart';
import 'package:taskly/Presentation/features/home/widgets/no_result_view.dart';
import 'package:taskly/Presentation/features/home/widgets/profile_avatar.dart';
import 'package:taskly/Presentation/features/home/widgets/stat_card.dart';
import 'package:taskly/Presentation/features/home/widgets/task_card.dart';

import '../../../Core/app_colors.dart';
import '../../../Core/app_strings.dart';
import '../../../Core/db_helper.dart';
import '../../../Core/task.dart';
import '../add_edit_task/add_edit_task_page.dart';
import '../task_details/task_details_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  final List<Task> _tasks = [];
  String _selectedFilter = AppStrings.all;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Task> taskFromDatabase = await DatabaseHelper.getTasks();
    if (!mounted) return;
    setState(() {
      _tasks.clear();
      _tasks.addAll(taskFromDatabase);
    });
  }

  List<Task> get _visibleTasks {
    if (_selectedFilter == AppStrings.pending) {
      return _tasks.where((task) => task.isCompleted == false).toList();
    } else if (_selectedFilter == AppStrings.completed) {
      return _tasks.where((task) => task.isCompleted == true).toList();
    } else {
      return _tasks;
    }
  }

  int get _completedCount =>
      _tasks.where((task) => task.isCompleted == true).length;

  int get _pendingCount =>
      _tasks.where((task) => task.isCompleted == false).length;

  void _onFilterTap(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  Future<void> _onStatusTap(Task task) async {
    task.isCompleted = !task.isCompleted;
    await DatabaseHelper.updateTask(task);
    await _loadTasks();
  }

  Future<void> _goToAddTask() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddEditTaskPage()),
    );
    await _loadTasks();
  }

  Future<void> _goToDetails(Task task) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TaskDetailsPage(task: task)),
    );
    await _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final List<Task> visibleTask = _visibleTasks;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 12,
            children: [
              const AppLogo(),
              const Text(
                AppStrings.appName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const ProfileAvatar(),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            const Text(
              AppStrings.goodMorning,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryText,
              ),
            ),
            const Text(
              AppStrings.userName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.format_list_bulleted,
                    iconColor: AppColors.primary,
                    count: _tasks.length,
                    label: AppStrings.total,
                  ),
                ),
                Expanded(
                  child: StatCard(
                    icon: Icons.schedule,
                    iconColor: AppColors.amberIcon,
                    count: _pendingCount,
                    label: AppStrings.pending,
                  ),
                ),
                Expanded(
                  child: StatCard(
                    icon: Icons.check_circle_outline,
                    iconColor: AppColors.greenIcon,
                    count: _completedCount,
                    label: AppStrings.completed,
                  ),
                ),
              ],
            ),
            Row(
              spacing: 7,
              children: [
                Expanded(
                  child: FilterButton(
                    label: AppStrings.all,
                    isSelected: _selectedFilter == AppStrings.all,
                    onTap: () => _onFilterTap(AppStrings.all),
                  ),
                ),
                Expanded(
                  child: FilterButton(
                    label: AppStrings.pending,
                    isSelected: _selectedFilter == AppStrings.pending,
                    onTap: () => _onFilterTap(AppStrings.pending),
                  ),
                ),
                Expanded(
                  child: FilterButton(
                    label: AppStrings.completed,
                    isSelected: _selectedFilter == AppStrings.completed,
                    onTap: () => _onFilterTap(AppStrings.completed),
                  ),
                ),
              ],
            ),
            if (_tasks.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppStrings.tasks,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.labelText,
                    ),
                  ),
                  Text(
                    '${visibleTask.length} ${AppStrings.tasks}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.labelText,
                    ),
                  ),
                ],
              ),
            if (_tasks.isEmpty) ...[
              EmptyTaskView(onAddTap: _goToAddTask),
            ] else if (visibleTask.isEmpty)
              const NoResultView(),
            Expanded(
              child: ListView.builder(
                itemCount: visibleTask.length,
                itemBuilder: (context, index) {
                  final currentTask = visibleTask[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TaskCard(
                      task: currentTask,
                      onTap: () => _goToDetails(currentTask),
                      onStatusTap: () => _onStatusTap(currentTask),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddTask,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}