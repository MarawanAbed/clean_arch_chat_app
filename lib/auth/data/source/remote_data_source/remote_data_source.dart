import 'package:clean_arch_chat/auth/domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource{
  Future<dynamic> signUp(UserEntity userEntity);
  Future<dynamic> signIn(UserEntity userEntity);
  Future<dynamic>createUser(UserEntity userEntity);
  Future<dynamic>forgetPassword(String email);
  Future<dynamic> currentUserId();
  Future<dynamic>sendVerificationEmail();
  Future<dynamic>isEmailVerified();
  Future<dynamic>signOut();

}