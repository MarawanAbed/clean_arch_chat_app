import 'package:clean_arch_chat/Chat/data/models/message_model.dart';
import 'package:clean_arch_chat/Chat/domain/entities/message_entity.dart';
import 'package:clean_arch_chat/Chat/domain/repo/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class AddTextMessageUseCase extends UseCase<dynamic,MessageModel>
{
  final HomeRepo repo;

  AddTextMessageUseCase(this.repo);
  @override
  Future call([MessageEntity? parameter])async {
    return await repo.addTextMessage(parameter!);
  }

}
