import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: const Text('Verify Email'),
    ),
    body: Column(
      children: [
        const Text("We've already sent you a verification email."),
        const Text("If you haven't receive an email, Click the button below."),
        TextButton(
          onPressed: () async{
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
           child: const Text('Send email verification')
          )
        ],
      )
    );
  }
}