import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapi/translation/locale_keys.g.dart';
import 'package:todoapi/view/auth/login_screen.dart';
import 'package:todoapi/view_model/cubits/auth_cubit.dart';
import 'package:todoapi/view_model/data/local/shared_helper.dart';
import 'package:todoapi/view_model/utils/app_colors.dart';
import 'package:todoapi/view_model/utils/navigation.dart';
import 'package:todoapi/view_model/utils/snackbar.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.purple,
        title: Text(
          LocaleKeys.todoApp.tr(),
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              if (context.locale.toString() == 'en') {
                context.setLocale(const Locale('ar'));
              } else {
                context.setLocale(const Locale('en'));
              }
            },
            icon: const Icon(
              Icons.translate,
              color: AppColors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.filter_list_rounded,
              color: AppColors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              SharedHelper.clearData();
              Navigation.pushAndRemove(context, const LoginScreen());
            },
            icon: const Icon(
              Icons.exit_to_app_rounded,
              color: AppColors.white,
            ),
          )
        ],
      ),
    );
  }
}
