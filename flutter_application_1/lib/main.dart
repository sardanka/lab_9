import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register/pages/registration_page.dart';
import 'register/bloc/register_bloc.dart';
import 'register/repository/register_repository.dart';
import 'rest_client/mobile_api_dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(MobileApiDio());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Register Form',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF64B5F6),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: BlocProvider(
        create: (context) => RegisterBloc(authRepository),
        child: const RegistrationPage(),
      ),
    );
  }
}