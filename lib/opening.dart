import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unipasaj/home.dart';
import 'package:unipasaj/login.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return MyHomePage();
          }
          else if(snapshot.hasError){
            return Center(child: Text("error"));
          }
          else{
            return LoggedInWidget();
          }
        },
      ),
    );
  }
}