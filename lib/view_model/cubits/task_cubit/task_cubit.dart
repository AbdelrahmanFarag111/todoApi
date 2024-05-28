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
    await DioHelper.get(
      path: EndPoints.tasks,
      queryParameters: {
        'page': page,
      },
      withToken: true,
    ).then((value) {
      for (var i in value.data['data']['tasks']) {
        tasks.add(Task.fromJson(i));
      }
      page++;
      emit(GetTaskSuccess());
    }).catchError((error) {
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

  ScrollController scrollController = ScrollController();

  void addScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        print('Bottom');
        getMoreTasks();
      }
    });
  }

  bool getMoreLoading = false;
  bool moreData = true;

  Future<void> getMoreTasks() async {
    if (getMoreLoading || !moreData) return;
    getMoreLoading = true;
    emit(GetMoreTaskLoading());
    await DioHelper.get(
      path: EndPoints.tasks,
      queryParameters: {
        'page': page,
      },
      withToken: true,
    ).then((value) {
      if (value.data['data']['tasks'].isEmpty) {
        moreData = false;
      } else {
        for (var i in value.data['data']['tasks']) {
          tasks.add(Task.fromJson(i));
        }
        page++;
      }
      getMoreLoading = false;
      emit(GetMoreTaskSuccess());
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 401) {
          emit(UnauthenticatedState());
        }
        debugPrint(error.response?.data.toString());
        getMoreLoading = false;
        emit(GetMoreTaskError(
            error.response?.data?.toString() ?? 'Error on Get Tasks'));
      }
      throw error;
    });
  }
}
