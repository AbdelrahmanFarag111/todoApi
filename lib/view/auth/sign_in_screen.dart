import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todoapi/translation/locale_keys.g.dart';
import 'package:todoapi/view/auth/login_screen.dart';
import 'package:todoapi/view/tasks/tasks_screen.dart';
import 'package:todoapi/view_model/cubits/auth_cubit.dart';
import 'package:todoapi/view_model/utils/app_assets.dart';
import 'package:todoapi/view_model/utils/app_colors.dart';
import 'package:todoapi/view_model/utils/navigation.dart';
import 'package:todoapi/view_model/utils/snackbar.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: AuthCubit.get(context).signInFormKey,
          child: ListView(
            padding: EdgeInsets.all(12.sp),
            children: [
              Image.asset(
                AppAssets.todo,
                height: 200.h,
              ),
              SizedBox(
                height: 12.h,
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: Text(
                  LocaleKeys.register.tr(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              TextFormField(
                controller: AuthCubit.get(context).nameController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.name.tr(),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return LocaleKeys.nameError.tr();
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 6.h,
              ),
              TextFormField(
                controller: AuthCubit.get(context).emailController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.email.tr(),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return LocaleKeys.emailError.tr();
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 6.h,
              ),
              TextFormField(
                controller: AuthCubit.get(context).passwordController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.password.tr(),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return LocaleKeys.passwordError.tr();
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 6.h,
              ),
              TextFormField(
                controller: AuthCubit.get(context).confirmPasswordController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.password_confirmation.tr(),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return LocaleKeys.password_confirmation.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Text(
                    LocaleKeys.doNotHaveAnAccount.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigation.push(context, const LoginScreen());

                    },
                    child: Text(
                      LocaleKeys.login.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is SignInSuccessState) {
                    SnackBarHelper.showMessage(context, 'Sign In Successfully');
                    Navigation.pushAndRemove(context, const TasksScreen());
                  } else if (state is SignInErrorState) {
                    SnackBarHelper.showError(context, state.msg);
                  }
                },
                builder: (context, state) {
                  if (state is SignInLoadingState) {
                    return const CircularProgressIndicator.adaptive();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      if (AuthCubit.get(context)
                          .formKey
                          .currentState!
                          .validate()) {
                        AuthCubit.get(context).signIn();
                      }
                    },
                    child: Text(
                      LocaleKeys.register.tr(),
                      style: TextStyle(fontSize: 16.sp, color: AppColors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
