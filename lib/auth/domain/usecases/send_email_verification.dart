import 'package:clean_arch_chat/auth/domain/repositories/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class SendEmailVerificationUseCase extends UseCase<void, NoParameter> {
  SendEmailVerificationUseCase(this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<void> call([NoParameter? parameter])async {
    return await authRepository.sendVerificationEmail();
  }
}