import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gchat/constants.dart';
import 'package:gchat/extensions.dart';
import 'package:gchat/navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with RestorationMixin {
  final _emailTextController = RestorableTextEditingController();
  final _passwordTextController = RestorableTextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _registerForRestoration() {
    registerForRestoration(_emailTextController, "emailTextController");
    registerForRestoration(_passwordTextController, "passwordTextController");
  }

  @override
  String? get restorationId => "LoginPageState";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    _registerForRestoration();
  }

  @override
  void initState() {
    super.initState();
    _registerForRestoration();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const Icon(Icons.arrow_back_ios),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 48.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              Text(
                "Login with your existing account",
                style: context.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailTextController.value,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: "Email"),
                validator: (name) {
                  if (name == null || name.isEmpty) {
                    return "Enter email address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordTextController.value,
                keyboardType: TextInputType.name,
                obscureText: true,
                decoration: const InputDecoration(hintText: "Password"),
                validator: (name) {
                  if (name == null || name.isEmpty) {
                    return "Enter password";
                  }
                  return null;
                },
              ),
              SizedBox(height: context.screenSize.height * .4),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text("Login"),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: context.textTheme.bodyLarge,
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: context.textTheme.bodyLarge
                            ?.copyWith(color: AppColor.primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.pushNamed(AppRoutes.signUp),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailTextController.value.text;
      final password = _passwordTextController.value.text;
      print("Email: $email, Password: $password");

      context.restorablePushReplacementNamed(AppRoutes.chats);
    }
  }
}
