import 'package:flutter/material.dart';
import 'package:gchat/constants.dart';
import 'package:gchat/extensions.dart';

class ProfileTile extends StatelessWidget {
  final String name;
  final String email;

  const ProfileTile({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    final names = name.split(" ");
    final firstNameInitial = names.first.characters.first;
    final lastNameInitial = names.last.characters.first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: context.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: context.textTheme.bodyLarge,
              ),
            ],
          )
        ],
      ),
    );
  }
}
