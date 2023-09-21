import 'package:clean_arch_chat/auth/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/auth/domain/repositories/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class SignInUseCase extends UseCase<dynamic, UserEntity> {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  @override
  Future<dynamic> call([UserEntity? parameter]) async {
    return await _authRepository.signIn(parameter!);
  }
}