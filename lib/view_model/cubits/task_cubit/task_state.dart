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

final class UnauthenticatedState extends TaskState {}
