import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gchat/constants.dart';
import 'package:gchat/extensions.dart';
import 'package:gchat/gen/assets.gen.dart';
import 'package:gchat/navigation.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.onboardingBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Center(
              child: Assets.images.icon.image(width: 100, height: 80),
            ),
            const SizedBox(height: 16),
            Text(
              "Hey!",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 32),
            ),
            const SizedBox(height: 10),
            Text("Welcome to GChat", style: context.textTheme.bodyLarge),
            const Spacer(flex: 1),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => context.restorablePushNamed(AppRoutes.signUp),
                child: const Text("GET STARTED"),
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: context.textTheme.bodyLarge,
                children: [
                  TextSpan(
                    text: "Login",
                    style: context.textTheme.bodyLarge
                        ?.copyWith(color: AppColor.primaryColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.pushNamed(AppRoutes.login);
                      },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
