import 'package:clean_arch_chat/auth/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/auth/domain/repositories/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class ForgetPasswordUseCase extends UseCase<dynamic, String> {
  final AuthRepository _authRepository;

  ForgetPasswordUseCase(this._authRepository);

  @override
  Future<dynamic> call([String? parameter]) async {
    return await _authRepository.forgetPassword(parameter!);
  }
}