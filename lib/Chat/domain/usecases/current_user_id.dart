import 'package:clean_arch_chat/Chat/domain/repo/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class HomeCurrentUserIdUseCase extends UseCase<dynamic, NoParameter> {
  final HomeRepo repo;

  HomeCurrentUserIdUseCase(this.repo);

  @override
  Future<dynamic> call([NoParameter? parameter]) async {
    return await repo.currentUserId();
  }
}