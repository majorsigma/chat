import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gchat/constants.dart';
import 'package:gchat/extensions.dart';
import 'package:gchat/features/chat/views/widgets/chat_tile.dart';
import 'package:gchat/features/user/models/user.dart';
import 'package:gchat/features/user/viewmodel/user_viewmodel.dart';
import 'package:gchat/navigation.dart';
import 'package:provider/provider.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UserViewModel>().getAllUsers();

    return StreamBuilder<List<GChatUser>>(
      stream: context.read<UserViewModel>().getAllUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<GChatUser>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitChasingDots(color: AppColor.primaryColor, size: 16),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("An error occurred"));
        } else if (snapshot.hasData) {
          final users = snapshot.data!;
          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                color: AppColor.primaryColor,
                thickness: 0.5,
              );
            },
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return ChatTile(
                user: users[index],
                onTap: () => context.restorablePushNamed(
                  AppRoutes.chatDm,
                  arguments: {"receipient": users[index].toMap()},
                ),
              );
            },
          );
        }
        return const Center(child: Text("No users found"));
      },
    );
  }
}
