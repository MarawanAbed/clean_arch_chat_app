import 'package:clean_arch_chat/Chat/data/repo_impl/repo_impl.dart';
import 'package:clean_arch_chat/Chat/data/source/data_source/data_source.dart';
import 'package:clean_arch_chat/Chat/data/source/data_source/data_source_imple.dart';
import 'package:clean_arch_chat/Chat/domain/repo/repo.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/add_image_message.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/add_text_message.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/current_user_id.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/get_all_message.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/get_all_user.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/get_single_user.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/search_users.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/sign_out.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/update_user.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/upload_image_profile.dart';
import 'package:clean_arch_chat/auth/data/repositories/repo_impl.dart';
import 'package:clean_arch_chat/auth/data/source/remote_data_source/remote_data_source.dart';
import 'package:clean_arch_chat/auth/data/source/remote_data_source/remote_data_source_impl.dart';
import 'package:clean_arch_chat/auth/domain/repositories/repo.dart';
import 'package:clean_arch_chat/auth/domain/usecases/create_user.dart';
import 'package:clean_arch_chat/auth/domain/usecases/current_user_id.dart';

import 'package:clean_arch_chat/auth/domain/usecases/forget_password.dart';
import 'package:clean_arch_chat/auth/domain/usecases/is_email_verified.dart';
import 'package:clean_arch_chat/auth/domain/usecases/send_email_verification.dart';

import 'package:clean_arch_chat/auth/domain/usecases/sign_in.dart';
import 'package:clean_arch_chat/auth/domain/usecases/sign_out.dart';
import 'package:clean_arch_chat/auth/domain/usecases/sign_up.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';


final sl = GetIt.instance;

Future<void> init() async {
  //use cases
  sl.registerLazySingleton<CurrentUserIdUseCase>(
      () => CurrentUserIdUseCase(sl.call()));
  sl.registerLazySingleton<CreateUserUseCase>(
      () => CreateUserUseCase(sl.call()));
  sl.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(sl.call()));
  sl.registerLazySingleton<IsEmailVerificationUseCase>(() => IsEmailVerificationUseCase(sl.call()));
  sl.registerLazySingleton<SendEmailVerificationUseCase>(() => SendEmailVerificationUseCase(sl.call()));
  sl.registerLazySingleton<SignInUseCase>(() => SignInUseCase(sl.call()));
  sl.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(sl.call()));
  sl.registerLazySingleton<HomeSignOutUseCase>(() => HomeSignOutUseCase(sl.call()));
  sl.registerLazySingleton<GetAllUserUseCase>(() => GetAllUserUseCase(sl.call()));
  sl.registerLazySingleton<UpdateUserUseCase>(() => UpdateUserUseCase(sl.call()));
  sl.registerLazySingleton<ForgetPasswordUseCase>(
      () => ForgetPasswordUseCase(sl.call()));

  //repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepoImpl(sl.call()));
  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl.call()));
  //remote data source
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(fireStore: sl.call(), auth: sl.call()));
  sl.registerLazySingleton<HomeDataSource>(
      () => HomeDataSourceImpl(firebaseStore: sl.call(), firebaseAuth: sl.call()));
  sl.registerLazySingleton<HomeCurrentUserIdUseCase>(
          () => HomeCurrentUserIdUseCase(sl.call()));
  sl.registerLazySingleton<UploadImageProfileUseCase>(
          () => UploadImageProfileUseCase(sl.call()));
  sl.registerLazySingleton<AddTextMessageUseCase>(() => AddTextMessageUseCase(sl.call()));
  sl.registerLazySingleton<AddImageMessageUseCase>(() => AddImageMessageUseCase(sl.call()));
  sl.registerLazySingleton<GetAllMessagesUseCase>(() => GetAllMessagesUseCase(sl.call()));
  sl.registerLazySingleton<SearchUserUseCases>(() => SearchUserUseCases(sl.call()));
  sl.registerLazySingleton<GetSingleUserUseCase>(
          () => GetSingleUserUseCase(sl.call()));
  //external
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);
}
