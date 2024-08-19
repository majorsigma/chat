import 'package:flutter/material.dart';
import 'package:gchat/constants.dart';
import 'package:gchat/extensions.dart';
import 'package:gchat/features/user/models/user.dart';

class ChatTile extends StatelessWidget {
  final GChatUser user;
  final VoidCallback? onTap;

  const ChatTile({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    final names = user.name.split(" ");
    final firstNameInitial = names.first.characters.first;
    final lastNameInitial = names.last.characters.first;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.iconBackground,
                  ),
                  child: Text(
                    names.length == 1
                        ? firstNameInitial
                        : "$firstNameInitial$lastNameInitial",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: user.isOnline ? Colors.green : Colors.grey,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Text(user.name, style: context.textTheme.bodyLarge)
          ],
        ),
      ),
    );
  }
}
