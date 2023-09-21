part of 'verify_cubit.dart';

@immutable
abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationEmailSent extends VerificationState {
}

class VerificationAlreadyVerified extends VerificationState {}

class VerificationSuccess extends VerificationState {}

class VerificationError extends VerificationState {
  final String errorMessage;

  VerificationError(this.errorMessage);
}

class VerificationSignOut extends VerificationState {}
