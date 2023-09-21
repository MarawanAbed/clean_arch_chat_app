import 'package:clean_arch_chat/auth/domain/repositories/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class CurrentUserIdUseCase extends UseCase<dynamic, NoParameter> {
  final AuthRepository _authRepository;

  CurrentUserIdUseCase(this._authRepository);

  @override
  Future<dynamic> call([NoParameter? parameter]) async {
    return await _authRepository.currentUserId();
  }
}