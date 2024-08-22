import 'package:flutter/material.dart';
import 'package:gchat/features/chat/views/chat_dm_page.dart';
import 'package:gchat/features/chat/views/chats_page.dart';
import 'package:gchat/features/onboarding/views/pages/login_page.dart';
import 'package:gchat/features/onboarding/views/pages/onboarding_page.dart';
import 'package:gchat/features/onboarding/views/pages/sign_up_page.dart';
import 'package:gchat/features/user/models/user.dart';
import 'package:gchat/utils.dart';

class AppRoutes {
  static final _logger = GChatUtils.getLogger("AppRoutes");

  static const String onboarding = "/";
  static const String signUp = "sign-up";
  static const String login = "login";
  static const String chats = "chats";
  static const String chatDm = "chat-dm";

  AppRoutes._privateConstructor();

  static final AppRoutes instance = AppRoutes._privateConstructor();

  Route<dynamic>? generateRoute(RouteSettings routeSettings) {
    final routeName = routeSettings.name;
    _logger.d("Route Name: $routeName");
    switch (routeName) {
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) => const OnboardingPage(),
        );
      case AppRoutes.signUp:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) => const SignUpPage(),
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) {
            return const LoginPage();
          },
        );
      case AppRoutes.chats:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) => const ChatsPage(),
        );
      case AppRoutes.chatDm:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) {
            final extraMap = routeSettings.arguments as Map;
            final user = GChatUser.fromMap(extraMap["receipient"]);
            return ChatDMPage(receipient: user);
          },
        );
      default:
        return null;
    }
  }
}
