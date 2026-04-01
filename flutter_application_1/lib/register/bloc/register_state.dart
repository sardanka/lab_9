// part of 'register_bloc.dart';

// @immutable
// sealed class RegisterState {}

// final class RegisterInitial extends RegisterState {}
// final class RegisterLoading extends RegisterState {}
// final class RegisterSuccess extends RegisterState {}
// final class RegisterFailure extends RegisterState {
//   final String error;
//   RegisterFailure(this.error);
// }

import '../../rest_client/profile.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterLoaded extends RegisterState {
  final Profile profile;

  RegisterLoaded(this.profile);
}

class RegisterError extends RegisterState {
  final String message;

  RegisterError(this.message);
}
