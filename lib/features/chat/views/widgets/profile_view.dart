import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gchat/constants.dart';
import 'package:gchat/extensions.dart';
import 'package:gchat/features/chat/views/widgets/profile_tile.dart';
import 'package:gchat/features/onboarding/viewmodel/signup_viewmodel.dart';
import 'package:gchat/features/user/models/user.dart';
import 'package:gchat/features/user/viewmodel/user_viewmodel.dart';
import 'package:gchat/navigation.dart';
import 'package:gchat/utils.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    context.read<UserViewModel>().getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<GChatUser>(
        future: context.read<UserViewModel>().getUserProfile(),
        builder: (BuildContext context, AsyncSnapshot<GChatUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitChasingDots(
                color: AppColor.primaryColor,
                size: 16,
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("An error occurred"),
            );
          } else if (snapshot.hasData) {
            final user = snapshot.data as GChatUser;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ProfileTile(name: user.name, email: user.email),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () async {
                    try {
                      await context.read<AuthViewModel>().signOut();
                      context.restorablePushReplacementNamed(AppRoutes.login);

                      GChatUtils.showSnackbar(
                        context,
                        "You have successfully signed out. See you soon.",
                        backgroundColor: Colors.lightGreen,
                      );
                    } catch (e) {
                      GChatUtils.showSnackbar(
                        context,
                        e.toString(),
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
