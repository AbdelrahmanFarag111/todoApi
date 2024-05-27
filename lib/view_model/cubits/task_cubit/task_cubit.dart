import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todoapi/model/task_model.dart';
import 'package:todoapi/view_model/data/network/dio_helper.dart';
import 'package:todoapi/view_model/data/network/end_points.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  static TaskCubit get(context) => BlocProvider.of<TaskCubit>(context);

  List<Task> tasks = [];
  int page = 1;

  Future<void> getTasks() async {
    page = 1;
    emit(GetTaskLoading());
    await DioHelper.get(path: EndPoints.tasks, queryParameters: {
      'page': page,
    },
    withToken: true,
    ).then((value) {
      for (var i in value.data['data']['tasks']) {
        tasks.add(Task.fromJson(i));
      }
      page++;
      emit(GetTaskSuccess());
    },).catchError((error){
      if (error is DioException) {
        if (error.response?.statusCode == 401) {
          emit(UnauthenticatedState());
        }
        debugPrint(error.response?.data.toString());
        emit(GetTaskError(
            error.response?.data?.toString() ?? 'Error on Get Tasks'));
      }
      throw error;
    });
  }
}
