import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gchat/features/chat/viewmodels/chat_viewmodel.dart';
import 'package:gchat/features/onboarding/viewmodel/signup_viewmodel.dart';
import 'package:gchat/features/user/viewmodel/user_viewmodel.dart';
import 'package:gchat/firebase_options.dart';
import 'package:gchat/navigation.dart';
import 'package:gchat/themes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => ChatsViewModel()),
      ],
      child: MaterialApp(
        title: 'GChat',
        restorationScopeId: "root",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? AppRoutes.onboarding
            : AppRoutes.chats,
        onGenerateRoute: AppRoutes.instance.generateRoute,
      ),
    );
  }
}
