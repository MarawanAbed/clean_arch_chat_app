import 'dart:io';

import 'package:clean_arch_chat/Chat/domain/entities/message_entity.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/add_image_message.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/add_text_message.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/get_all_message.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/upload_image_profile.dart';
import 'package:clean_arch_chat/utils/common/common.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(
      {required this.addText,
      required this.addImage,
      required this.uploadImage,
      required this.getAllMessages,
      })
      : super(ChatInitial());
  final AddTextMessageUseCase addText;
  final AddImageMessageUseCase addImage;
  final UploadImageProfileUseCase uploadImage;
  final GetAllMessagesUseCase getAllMessages;
  static ChatCubit get(context) => BlocProvider.of(context);
  var picker = ImagePicker();

  addTextMessage(MessageEntity message) async {
    try {
      emit(ChatAddTextMessageLoading());
      await addText.call(message);
      emit(ChatAddTextMessageSuccess());
    } catch (e) {
      emit(ChatAddTextMessageError(e.toString()));
    }
  }

  Future<void> pickAndSendImage(String receiverId) async {
    try {
      emit(ChatUploadImageLoading());
      final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);

        // Upload the image and get the image URL
        final imageUrl = await uploadImage(imageFile);

        // Send the image URL as a message
        await addTextMessage(
          MessageEntity(
            chatSenderId: FirebaseAuth.instance.currentUser!.uid,
            chatReceiverId: receiverId,
            chatContent: imageUrl,
            chatSendTime: DateTime.now(),
            chatMessageType: MessageType.imageType,
          ),
        );
        emit(ChatUploadImageSuccess());
      } else {
        emit(ChatUploadImageError(Utils.showSnackBar('No image selected',)));
      }
    } catch (e) {
      emit(ChatUploadImageError(e.toString()));
    }
  }

  List<MessageEntity>message=[];
  getMessages(String receiverId) async {
    try {
      emit(ChatGetAllMessagesLoading());
      getAllMessages(receiverId).listen((List<MessageEntity> newMessages) {
        message = newMessages;
        emit(ChatGetAllMessagesSuccess());
    });
    } catch (e) {
      print(e.toString());
      emit(ChatGetAllMessagesError(e.toString()));
    }
  }
}
