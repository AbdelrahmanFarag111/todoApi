import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todoapi/view_model/data/local/shared_helper.dart';
import 'package:todoapi/view_model/data/local/shared_keys.dart';
import 'package:todoapi/view_model/data/network/dio_helper.dart';
import 'package:todoapi/view_model/data/network/end_points.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  void login() async {
    emit(LoginLoadingState());
    await DioHelper.post(
      path: EndPoints.login,
      body: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    ).then((value) {
      // print(value.data);
      SharedHelper.saveData(
          SharedKeys.userName, value.data['data']['user']['name']);
      SharedHelper.saveData(
          SharedKeys.email, value.data['data']['user']['email']);
      SharedHelper.saveData(SharedKeys.token, value.data['data']['token']);
      emit(LoginSuccessState());
    }).catchError((error) {
      if (error is DioException) {
        // print(error.response?.data);
        emit(LoginErrorState(
          error.response?.data['message'] ?? 'Error on Login',
        ));
      }
    });
  }

  void signIn() async {
    emit(SignInLoadingState());
    await DioHelper.post(
      path: EndPoints.register,
      body: {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
      },
    ).then((value) {
      // print(value.data);
      SharedHelper.saveData(
          SharedKeys.userName, value.data['data']['user']['name']);
      SharedHelper.saveData(
          SharedKeys.email, value.data['data']['user']['email']);
      SharedHelper.saveData(SharedKeys.token, value.data['data']['token']);
      emit(SignInSuccessState());
    }).catchError((error) {
      if (error is DioException) {
        // print(error.response?.data);
        emit(SignInErrorState(
          error.response?.data['message'] ?? 'Error on SignIn',
        ));
      }
    });
  }
  void logout() async {
    emit(LogoutLoadingState());
    await DioHelper.post(
      path: EndPoints.logout,
      withToken: true
    ).then((value) {
      // print(value.data);
      emit(LogoutSuccessState());
    }).catchError((error) {
      if (error is DioException) {
        // print(error.response?.data);
        emit(LogoutErrorState(
          error.response?.data['message'] ?? 'Error on Logout',
        ));
      }
    });
  }

}
