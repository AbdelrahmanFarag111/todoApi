import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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

  void initData(int index) {
    titleController.text = tasks[index].title ?? '';
    descriptionController.text = tasks[index].description ?? '';
    startDateController.text = tasks[index].startDate ?? '';
    endDateController.text = tasks[index].endDate ?? '';
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  void clearData() {
    titleController.clear();
    descriptionController.clear();
    startDateController.clear();
    endDateController.clear();
    image = null;
  }

  final ImagePicker picker = ImagePicker();
  XFile? image;

  void selectImage() async {
    image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    emit(SelectImageState());
  }

  Future<void> addTask() async {
    emit(AddTaskLoading());
    Task task = Task(
      title: titleController.text,
      description: descriptionController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
      status: 'new',
    );
    FormData formData = FormData.fromMap(
      {
        ...task.toJson(),
        if (image != null) 'image': await MultipartFile.fromFile(image!.path),
      },
    );
    await DioHelper.post(
      path: EndPoints.tasks,
      formData: formData,
    ).then((value) {
      tasks.insert(0, Task.fromJson(value.data['data']));
      clearData();
      emit(AddTaskSuccess());
    }).catchError((error) {
      if (error is DioException) {
      }
      emit(AddTaskError());
      throw error;
    });
  }

  Future<void> editTask(int index) async {
    emit(EditTaskLoading());
    Task task = Task(
      title: titleController.text,
      description: descriptionController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
      status: tasks[index].status,
    );
    FormData formData = FormData.fromMap(
      {
        ...task.toJson(),
        if (image != null) 'image': await MultipartFile.fromFile(image!.path),
      },
    );
    await DioHelper.post(
      path: '${EndPoints.tasks}/${tasks[index].id}',
      formData: formData,
    ).then((value) {
      clearData();
      emit(EditTaskSuccess());
    }).catchError((error) {
      if (error is DioException) {
      }
      emit(EditTaskError());
      throw error;
    });
  }

  Future<void> delete(int index) async {
    emit(DeleteTaskLoading());
    await DioHelper.delete(
      path: '${EndPoints.tasks}/${tasks[index].id}',
      withToken: true,
    ).then((value) async{
      await getTasks();
      emit(DeleteTaskSuccess());
    }).catchError((error) {
      debugPrint(error.response?.data.toString());
      emit(DeleteTaskError());
    });
  }
}
