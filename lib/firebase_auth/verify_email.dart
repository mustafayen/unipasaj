import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unipasaj/firebase_auth/sign_in_provider.dart';
import 'package:unipasaj/home.dart';
import 'package:unipasaj/login.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

//NOT: Register olduktan sonra verification yaptıktan sonra, logout olup tekrar login olunca app crash attı

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    //call after email verification
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  void sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? MyHomePage()
      : Scaffold(
          appBar: AppBar(
            title: Text('Verify email'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'email doğrulama linki e-posta adresinize iletilmiştir.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: sendVerificationEmail,
                  icon: Icon(Icons.email),
                  label: Text("Tekrar mail gönderin"),
                ),
                ElevatedButton(onPressed: (){
                  final provider = Provider.of<EmailSignInProvider>(
                  context, listen: false);
                  provider.signOut();
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoggedInWidget()));
                  },
                    child: Text("Çıkış yap"))
              ],
            ),
          ),
        );
}
