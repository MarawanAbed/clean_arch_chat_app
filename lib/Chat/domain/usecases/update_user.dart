import 'package:clean_arch_chat/Chat/domain/repo/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class UpdateUserUseCase extends UseCase<dynamic,Map<String,dynamic>>{
  final HomeRepo repo;

  UpdateUserUseCase(this.repo);
  @override
  Future call([Map<String,dynamic>? parameter]) async{
    return await repo.updateUser(parameter!);
  }
}