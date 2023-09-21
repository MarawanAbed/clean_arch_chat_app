import 'package:clean_arch_chat/auth/data/source/remote_data_source/remote_data_source.dart';
import 'package:clean_arch_chat/auth/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/auth/domain/repositories/repo.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepoImpl(this._remoteDataSource);

  @override
  Future createUser(UserEntity userEntity) async {
    return await _remoteDataSource.createUser(userEntity);
  }

  @override
  Future currentUserId() async {
    return await _remoteDataSource.currentUserId();
  }

  @override
  Future forgetPassword(String email) async {
    return await _remoteDataSource.forgetPassword(email);
  }

  @override
  Future signIn(UserEntity userEntity) async {
    return await _remoteDataSource.signIn(userEntity);
  }

  @override
  Future signUp(UserEntity userEntity) async {
    return await _remoteDataSource.signUp(userEntity);
  }

  @override
  Future sendVerificationEmail() async {
    return await _remoteDataSource.sendVerificationEmail();
  }

  @override
  Future isEmailVerified() async {
    return await _remoteDataSource.isEmailVerified();
  }

  @override
  Future signOut() async {
    return await _remoteDataSource.signOut();
  }
}
