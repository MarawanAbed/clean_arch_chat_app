import 'package:clean_arch_chat/Chat/domain/repo/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class GetAllUserUseCase extends UseCase<dynamic,NoParameter>
{
  final HomeRepo repo;

  GetAllUserUseCase(this.repo);
  @override
  Future call([NoParameter? parameter])async {
    return await repo.getAllUser();
  }
}