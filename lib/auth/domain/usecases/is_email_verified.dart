import 'package:clean_arch_chat/auth/domain/repositories/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class IsEmailVerificationUseCase extends UseCase<dynamic, NoParameter> {
  IsEmailVerificationUseCase( this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<dynamic> call([NoParameter? parameter])async {
    return await authRepository.isEmailVerified();
  }
}