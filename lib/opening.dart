import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unipasaj/firebase_auth/verify_email.dart';
import 'package:unipasaj/home.dart';
import 'package:unipasaj/login.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Get the authenticated user from the snapshot
              //User? user = snapshot.data;
              //return MyHomePage(user: user!); // Pass the user to MyHomePage
              return VerifyEmailPage();
            } else if (snapshot.hasError) {
              return Center(child: Text("Error"));
            } else {
              return LoggedInWidget();
            }
          },
        ),
      ),
    );
  }
}
