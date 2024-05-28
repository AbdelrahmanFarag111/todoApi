import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoapi/model/task_model.dart';
import 'package:todoapi/view_model/cubits/task_cubit/task_cubit.dart';
import 'package:todoapi/view_model/utils/app_colors.dart';
import 'package:todoapi/view_model/utils/snackbar.dart';



// ignore: must_be_immutable
class TaskWidget extends StatelessWidget {
  TaskWidget({super.key, required this.task, required this.index});

  Task task;
  int index;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          // A SlidableAction can have an icon and/or a label.
          BlocConsumer<TaskCubit, TaskState>(
            listener: (context, state) {
              if (state is DeleteTaskSuccess) {
                SnackBarHelper.showMessage(
                    context, 'Task Deleted Successfully');
              } else if (state is DeleteTaskError) {
                SnackBarHelper.showError(context, 'error on event');
              }
            },
            builder: (context, state) {
              return SlidableAction(
                onPressed: (BuildContext context) {
                  TaskCubit.get(context).delete(index);
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              );
            },
          ),
        ],
      ),
      child: Material(
        color: AppColors.cyan.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: checkStatus(task.status ?? ''),
                width: 2.w,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title ?? '',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Text(
                  task.description ?? '',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 14.sp,
                  ),
                ),
                Visibility(
                  visible: task.image != null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      task.image ?? '',
                      height: 200.h,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.purple,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 6.w,
                            ),
                            Expanded(
                              child: Text(
                                task.startDate ?? '',
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.purple,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.timer_off_outlined,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 6.w,
                            ),
                            Expanded(
                              child: Text(
                                task.endDate ?? '',
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color checkStatus(String status) {
  switch (status) {
    case 'outdated':
      return Colors.black54;
    case 'compeleted':
      return Colors.green;
    case 'doing':
      return Colors.blue;
    default:
      return AppColors.purple;
  }
}

/*
*
*  showModalBottomSheet(
            context: context,
            enableDrag: true,
            isDismissible: true,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (context) {
              return Padding(
                padding: EdgeInsetsDirectional.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 12.w,
                    ),
                    Expanded(
                      child: Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        child: Center(
                          child: Text(
                            LocaleKeys.edit.tr(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                              fontSize: 18.sp
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Expanded(
                      child: Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        child: Center(
                          child: Text(
                            LocaleKeys.delete.tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                                fontSize: 18.sp
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                  ],
                ),
              );
            },
          );
*
*
* */
