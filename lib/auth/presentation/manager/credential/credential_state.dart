part of 'credential_cubit.dart';

@immutable
abstract class CredentialState {}

class CredentialInitial extends CredentialState {}

class CredentialLoading extends CredentialState {}


class SignInSuccess extends CredentialState {}
class SignInLoading extends CredentialState {}
class SignInError extends CredentialState {
  final String message;

  SignInError(this.message);
}
class SignUpSuccess extends CredentialState {}
class SignUpLoading extends CredentialState {}
class SignUpError extends CredentialState {
  final String message;

  SignUpError(this.message);
}
class ForgetPasswordSuccess extends CredentialState {}
class ForgetPasswordLoading extends CredentialState {}
class ForgetPasswordError extends CredentialState {
  final String message;

  ForgetPasswordError(this.message);
}


class ChangePasswordVisibility extends CredentialState {}