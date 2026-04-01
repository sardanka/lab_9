// part of 'register_bloc.dart';

// @immutable
// sealed class RegisterEvent {}

// class RegisterSubmitted extends RegisterEvent {
//   final String email;
//   final String password;

//   RegisterSubmitted({required this.email, required this.password});
// }

abstract class RegisterEvent {}

class LoadProfileEvent extends RegisterEvent {}
