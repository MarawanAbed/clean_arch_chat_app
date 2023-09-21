import 'dart:io';

import 'package:clean_arch_chat/Chat/domain/repo/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class UploadImageProfileUseCase extends UseCase<String,File>
{
  final HomeRepo repo;

  UploadImageProfileUseCase(this.repo);

  @override
  Future<String> call([File? parameter])async {
    return await repo.uploadProfileImage(parameter!);
  }
}