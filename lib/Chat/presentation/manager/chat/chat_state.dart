part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatAddTextMessageLoading extends ChatState {}

class ChatAddTextMessageSuccess extends ChatState {}

class ChatAddTextMessageError extends ChatState {
  final String error;

  ChatAddTextMessageError(this.error);
}
class ChatUploadImageLoading extends ChatState {}

class ChatUploadImageSuccess extends ChatState {}

class ChatUploadImageError extends ChatState {
  final String error;

  ChatUploadImageError(this.error);
}
class ChatGetAllMessagesLoading extends ChatState {}

class ChatGetAllMessagesSuccess extends ChatState {}

class ChatGetAllMessagesError extends ChatState {
  final String error;

  ChatGetAllMessagesError(this.error);
}