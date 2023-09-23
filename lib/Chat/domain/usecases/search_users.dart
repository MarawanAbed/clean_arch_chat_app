import 'package:clean_arch_chat/Chat/domain/repo/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class SearchUserUseCases extends UseCase<dynamic,String>
{
  final HomeRepo repo;

  SearchUserUseCases(this.repo);

  @override
  Future call([String? parameter])async {
    return await repo.searchUser(parameter!);
  }
}