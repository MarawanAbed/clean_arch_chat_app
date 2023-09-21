import 'package:clean_arch_chat/auth/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/auth/domain/repositories/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class CreateUserUseCase extends UseCase<dynamic, UserEntity> {
  final AuthRepository authRepository;

  CreateUserUseCase(this.authRepository);

  @override
  Future<dynamic> call([UserEntity? parameter]) async {
    return await authRepository.createUser(parameter!);
  }
}
