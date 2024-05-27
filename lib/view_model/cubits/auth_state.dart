part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoginLoadingState extends AuthState {}

final class LoginSuccessState extends AuthState {}

final class LoginErrorState extends AuthState {
  final String msg;

  LoginErrorState(this.msg);
}

final class SignInLoadingState extends AuthState {}

final class SignInSuccessState extends AuthState {}

final class SignInErrorState extends AuthState {
  final String msg;

  SignInErrorState(this.msg);
}

final class LogoutLoadingState extends AuthState {}

final class LogoutSuccessState extends AuthState {}

final class LogoutErrorState extends AuthState {
  final String msg;

  LogoutErrorState(this.msg);
}
