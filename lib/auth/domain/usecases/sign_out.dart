import 'package:clean_arch_chat/auth/domain/repositories/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class SignOutUseCase extends UseCase<dynamic, NoParameter> {
  SignOutUseCase( this.repository);

  final AuthRepository repository;

  @override
  Future call([NoParameter? parameter])async {
    return await repository.signOut();
  }


}