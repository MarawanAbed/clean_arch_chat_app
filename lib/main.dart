import 'package:clean_arch_chat/Chat/domain/usecases/add_image_message.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/add_text_message.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/get_all_message.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/get_all_user.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/get_single_user.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/search_users.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/update_user.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/upload_image_profile.dart';
import 'package:clean_arch_chat/Chat/presentation/manager/Home/home_cubit.dart';
import 'package:clean_arch_chat/Chat/presentation/manager/chat/chat_cubit.dart';
import 'package:clean_arch_chat/auth/domain/usecases/create_user.dart';
import 'package:clean_arch_chat/auth/domain/usecases/forget_password.dart';
import 'package:clean_arch_chat/auth/domain/usecases/sign_in.dart';
import 'package:clean_arch_chat/auth/domain/usecases/sign_up.dart';
import 'package:clean_arch_chat/auth/domain/usecases/upload_image.dart';
import 'package:clean_arch_chat/auth/presentation/manager/credential/credential_cubit.dart';
import 'package:clean_arch_chat/firebase_options.dart';
import 'package:clean_arch_chat/utils/routes/routes.dart';
import 'package:clean_arch_chat/utils/services/bloc_observer.dart';
import 'package:clean_arch_chat/utils/services/services_locator.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:clean_arch_chat/utils/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Chat/domain/usecases/sign_out.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((message) async {
    Utils.showSnackBar(message.notification!.body!);
  });
  Bloc.observer = MyBlocObserver();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasShownSplash = prefs.getBool('hasShownSplash') ?? false;
  runApp(MyApp(
    hasShownSplash: hasShownSplash,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.hasShownSplash});

  final bool hasShownSplash;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(
            uploadImage: sl<UploadImageProfileUseCase>(),
            singleUser: sl<GetSingleUserUseCase>(),
            getUser: sl<GetAllUserUseCase>(),
            updateUser: sl<UpdateUserUseCase>(),
            signOut: sl<HomeSignOutUseCase>(),
            searchUserUseCases: sl<SearchUserUseCases>(),
          )..getSingleUserMethod(FirebaseAuth.instance.currentUser!.uid),
        ),
        BlocProvider(
          create: (context) => ChatCubit(
            addText: sl<AddTextMessageUseCase>(),
            addImage: sl<AddImageMessageUseCase>(),
            uploadImage: sl<UploadImageProfileUseCase>(),
            getAllMessages: sl<GetAllMessagesUseCase>(),
          ),
        ),
      ],
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null && user.emailVerified) {
              return MaterialApp(
                scaffoldMessengerKey: Utils.messengerKey,
                title: 'Chat App',
                debugShowCheckedModeBanner: false,
                theme: lightThemeData(context),
                darkTheme: darkThemeData(context),
                themeMode: ThemeMode.system,
                initialRoute: '/home',
                onGenerateRoute: OnGenerateRoutes.route,
              );
            } else {
              // User is signed in but email is not verified, navigate to verify email screen.
              return MaterialApp(
                scaffoldMessengerKey: Utils.messengerKey,
                title: 'Chat App',
                debugShowCheckedModeBanner: false,
                theme: lightThemeData(context),
                darkTheme: darkThemeData(context),
                themeMode: ThemeMode.system,
                initialRoute: '/verifyEmail',
                onGenerateRoute: OnGenerateRoutes.route,
              );
            }
          } else {
            // User is not signed in, navigate to auth screen.
            return BlocProvider(
              create: (context) => CredentialCubit(
                signIn: sl<SignInUseCase>(),
                signUp: sl<SignUpUseCase>(),
                forgetPassword: sl<ForgetPasswordUseCase>(),
                createUser: sl<CreateUserUseCase>(),
                uploadImage: sl<UploadImageUseCase>(),
              ),
              child: MaterialApp(
                scaffoldMessengerKey: Utils.messengerKey,
                title: 'Chat App',
                debugShowCheckedModeBanner: false,
                theme: lightThemeData(context),
                darkTheme: darkThemeData(context),
                themeMode: ThemeMode.system,
                initialRoute: widget.hasShownSplash ? '/auth' : '/',
                onGenerateRoute: OnGenerateRoutes.route,
              ),
            );
          }
        },
      ),
    );
  }
}
