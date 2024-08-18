import 'package:flutter/material.dart';
import 'package:gchat/constants.dart';
import 'package:gchat/extensions.dart';
import 'package:gchat/navigation.dart';

class ChatTile extends StatelessWidget {
  final String name;

  const ChatTile({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final names = name.split(" ");
    final firstNameInitial = names.first.characters.first;
    final lastNameInitial = names.last.characters.first;

    return GestureDetector(
      onTap: () => context.restorablePushNamed(AppRoutes.chatDm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white,
        child: Row(
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
                "$firstNameInitial$lastNameInitial",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              name,
              style: context.textTheme.bodyLarge,
            )
          ],
        ),
      ),
    );
  }
}
