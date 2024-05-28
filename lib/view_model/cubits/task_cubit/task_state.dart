part of 'task_cubit.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

final class GetTaskLoading extends TaskState {}

final class GetTaskSuccess extends TaskState {}

final class GetTaskError extends TaskState {
  final String msg;

  GetTaskError(this.msg);
}

final class GetMoreTaskLoading extends TaskState {}

final class GetMoreTaskSuccess extends TaskState {}

final class GetMoreTaskError extends TaskState {
  final String msg;

  GetMoreTaskError(this.msg);
}

final class AddTaskLoading extends TaskState {}

final class AddTaskSuccess extends TaskState {}

final class AddTaskError extends TaskState {}

final class EditTaskLoading extends TaskState {}

final class EditTaskSuccess extends TaskState {}

final class EditTaskError extends TaskState {}

final class DeleteTaskLoading extends TaskState {}

final class DeleteTaskSuccess extends TaskState {}

final class DeleteTaskError extends TaskState {}

final class UnauthenticatedState extends TaskState {}

final class SelectImageState extends TaskState {}
