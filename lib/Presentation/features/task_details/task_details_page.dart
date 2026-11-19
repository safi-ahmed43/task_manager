import 'package:flutter/material.dart';
import 'package:taskly/Presentation/features/task_details/widget/action_button.dart';
import 'package:taskly/Presentation/features/task_details/widget/delete_confirm_sheet.dart';
import 'package:taskly/Presentation/features/task_details/widget/info_pill.dart';
import 'package:taskly/Presentation/features/task_details/widget/info_row.dart';

import '../../../Core/app_colors.dart';
import '../../../Core/app_strings.dart';
import '../../../Core/db_helper.dart';
import '../../../Core/task.dart';
import '../../core/square_button.dart';
import '../add_edit_task/add_edit_task_page.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({super.key, required this.task});

  final Task task;

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late Task _task;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  Future<void> _refreshTask() async {
    final tasks = await DatabaseHelper.getTasks();
    if (!mounted) return;

    try {
      final updated = tasks.firstWhere((item) => item.id == _task.id);
      setState(() {
        _task = updated;
      });
    } catch (_) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _toggleStatus() async {
    if (_isBusy) return;
    setState(() => _isBusy = true);

    try {
      _task.isCompleted = !_task.isCompleted;
      await DatabaseHelper.updateTask(_task);
      if (!mounted) return;
      setState(() {});
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  Future<void> _openEditPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditTaskPage(task: _task),
      ),
    );
    await _refreshTask();
  }

  void _openDeleteSheet() {
    if (_isBusy) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DeleteConfirmSheet(
        onConfirm: _deleteTask,
      ),
    );
  }

  Future<void> _deleteTask() async {
    if (_isBusy || _task.id == null) return;
    setState(() => _isBusy = true);

    try {
      await DatabaseHelper.deleteTask(_task.id!);
      if (!mounted) return;
      Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = _task.isCompleted;
    final String descriptionText = _task.description.trim().isNotEmpty
        ? _task.description
        : '${AppStrings.description} ${AppStrings.optional}';
    final String dueDateText =
    _task.dueDate.trim().isNotEmpty ? _task.dueDate : AppStrings.dueDateHint;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: SquareIconButton(
          icon: Icons.arrow_back,
          onTap: () => Navigator.of(context).pop(),
        ),
        title: const Text(AppStrings.taskDetails),
        actions: [
          SquareIconButton(
            icon: Icons.edit,
            onTap: _openEditPage,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(11),
                boxShadow: AppColors.cardShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        InfoPill(
                          text: '${_task.priority} ${AppStrings.priorityLabel}',
                          textColor: AppColors.priorityText(_task.priority),
                          backgroundColor:
                          AppColors.priorityBackground(_task.priority),
                        ),
                        InfoPill(
                          text: isCompleted
                              ? AppStrings.completed
                              : AppStrings.pending,
                          textColor:
                          isCompleted ? AppColors.green : AppColors.primary,
                          backgroundColor: isCompleted
                              ? AppColors.greenLight
                              : AppColors.primaryLight,
                        ),
                      ],
                    ),
                    Text(
                      _task.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    InfoRow(
                      icon: Icons.calendar_month,
                      label: AppStrings.dueDate,
                      value: dueDateText,
                      valueColor: AppColors.red,
                    ),
                    InfoRow(
                      icon: Icons.lock_clock,
                      label: AppStrings.created,
                      value: _task.createdDate,
                      valueColor: AppColors.primaryText,
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              AppStrings.description,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(11),
                boxShadow: AppColors.cardShadow,
              ),
              child: Text(
                descriptionText,
                style: const TextStyle(fontSize: 14, color: AppColors.bodyText),
              ),
            ),
            ActionButton(
              icon: isCompleted ? Icons.undo : Icons.done,
              label: isCompleted
                  ? AppStrings.markAsPending
                  : AppStrings.markAsCompleted,
              textColor: AppColors.white,
              borderColor:
              isCompleted ? AppColors.amberIcon : AppColors.primary,
              backgroundColor:
              isCompleted ? AppColors.amberIcon : AppColors.primary,
              onTap: _toggleStatus,
            ),
            ActionButton(
              icon: Icons.delete_outline,
              label: AppStrings.deleteTask,
              textColor: AppColors.red,
              borderColor: AppColors.red,
              backgroundColor: AppColors.white,
              onTap: _openDeleteSheet,
            ),
          ],
        ),
      ),
    );
  }
}