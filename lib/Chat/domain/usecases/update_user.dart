import 'package:clean_arch_chat/Chat/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/Chat/domain/repo/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class UpdateUserUseCase extends UseCase<dynamic,UserEntity>{
  final HomeRepo repo;

  UpdateUserUseCase(this.repo);
  @override
  Future call([UserEntity? parameter]) async{
    return await repo.updateUser(parameter!);
  }
}