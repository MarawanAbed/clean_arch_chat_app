import 'dart:io';

import 'package:clean_arch_chat/auth/domain/repositories/repo.dart';
import 'package:clean_arch_chat/utils/usecases/use_case.dart';

class UploadImageUseCase extends UseCase<dynamic, File> {
  final AuthRepository _repo;

  UploadImageUseCase(this._repo);

  @override
  Future call([File? parameter]) async {
    return await _repo.uploadImage(parameter!);
  }
}
