import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unipasaj/extensions/context_extensions.dart';
import 'package:unipasaj/extensions/string_extensions.dart';
import 'package:unipasaj/firebase_auth/auth_services.dart';
import 'package:unipasaj/firebase_auth/verify_email.dart';
import 'package:unipasaj/home.dart';
import 'package:unipasaj/localization/locale_keys.g.dart';
import 'package:unipasaj/widgets/auth/auth_common_card.dart';
import 'package:unipasaj/widgets/input/text_input.dart';

class LoggedInWidget extends StatefulWidget {
  @override
  State<LoggedInWidget> createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget>
    with SingleTickerProviderStateMixin {
  late TextEditingController t1 = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  final FirebaseAuthService _auth = FirebaseAuthService();

  late TabController _tabController;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: "Giriş Yap"),
            Tab(text: "Kayıt Ol"),
          ],
        ),
        title: Text(
          LocaleKeys.appName.translate,
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(color: Colors.white),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AuthCommonCard(
            child: _loginPart(),
            title: LocaleKeys.loginButtonText.translate,
          ),
          AuthCommonCard(
            child: _registerPart(),
            title: LocaleKeys.signUpButtonText.translate,
          )
        ],
      ),
    );

    // return PopScope(
    //   canPop: true,
    //   onPopInvoked: (didPop) {},
    //   child: Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: Colors.black,
    //       bottom: TabBar(
    //         controller: _tabController,
    //         tabs: const <Widget>[
    //           Tab(text: "Giriş Yap"),
    //           Tab(text: "Kayıt Ol"),
    //         ],
    //       ),
    //     ),
    //     body: TabBarView(
    //       controller: _tabController,
    //       children: <Widget>[
    //         Container(
    //           child: SingleChildScrollView(
    //             child: Column(
    //               children: <Widget>[
    //                 SizedBox(
    //                   height: 50,
    //                 ),
    //                 Text('ÜNİPASAJ',
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                       color: Colors.black,
    //                       fontSize: 25,
    //                       fontWeight: FontWeight.bold,
    //                       letterSpacing: 2.0,
    //                     )),
    //                 SizedBox(
    //                   height: 50,
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(horizontal: 15),
    //                   child: TextFormField(
    //                     controller: _emailController,
    //                     decoration: InputDecoration(
    //                       border: OutlineInputBorder(
    //                         borderRadius: BorderRadius.circular(
    //                             15.0), // Set the border radius
    //                       ),
    //                       filled: true,
    //                       fillColor: Colors.blue[
    //                           100], // Set your desired background color here
    //                       labelText: 'Email',
    //                       hintText: 'edu.tr uzantılı adresinizi giriniz',
    //                     ),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.only(
    //                       left: 15.0, right: 15.0, top: 15, bottom: 15),
    //                   child: TextFormField(
    //                     controller: _passwordController,
    //                     obscureText: true,
    //                     decoration: InputDecoration(
    //                       border: OutlineInputBorder(
    //                         borderRadius: BorderRadius.circular(
    //                             15.0), // Set the border radius
    //                       ),
    //                       labelText: 'Şifre',
    //                       filled: true,
    //                       fillColor: Colors.blue[100],
    //                     ),
    //                   ),
    //                 ),
    //                 Column(
    //                   children: [
    //                     ElevatedButton(
    //                       onPressed: _signIn,
    //                       child: Text(
    //                         'Giriş',
    //                         style: TextStyle(color: Colors.white, fontSize: 25),
    //                       ),
    //                       style: ButtonStyle(
    //                         backgroundColor:
    //                             MaterialStateProperty.resolveWith<Color?>(
    //                           (Set<MaterialState> states) {
    //                             if (states.contains(MaterialState.pressed)) {
    //                               // Color when the button is pressed
    //                               return Colors.amberAccent.withOpacity(
    //                                   0.5); // Adjust the opacity as needed
    //                             }
    //                             // Color for other states (e.g., normal)
    //                             return Colors.amberAccent;
    //                           },
    //                         ),
    //                       ),
    //                     ),
    //                     TextButton(
    //                         onPressed: resetPassword,
    //                         child: Text(
    //                             "Şifremi unuttum\n(Email adresinizi yazıp tıklayınız)")),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         Container(
    //           child: SingleChildScrollView(
    //             child: Column(
    //               children: [
    //                 SizedBox(
    //                   height: 50,
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(horizontal: 15),
    //                   child: TextFormField(
    //                     controller: _nameController,
    //                     autofillHints: [AutofillHints.name],
    //                     decoration: InputDecoration(
    //                       border: OutlineInputBorder(
    //                         borderRadius: BorderRadius.circular(
    //                             15.0), // Set the border radius
    //                       ),
    //                       filled: true,
    //                       fillColor: Colors.green[
    //                           100], // Set your desired background color here
    //                       labelText: "İsim",
    //                     ),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.only(
    //                       left: 15.0, right: 15.0, top: 15, bottom: 0),
    //                   child: TextFormField(
    //                     controller: _surnameController,
    //                     autofillHints: [AutofillHints.name],
    //                     decoration: InputDecoration(
    //                       border: OutlineInputBorder(
    //                         borderRadius: BorderRadius.circular(
    //                             15.0), // Set the border radius
    //                       ),
    //                       filled: true,
    //                       fillColor: Colors.green[
    //                           100], // Set your desired background color here
    //                       labelText: "Soyisim",
    //                     ),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.only(
    //                       left: 15.0, right: 15.0, top: 15, bottom: 0),
    //                   child: TextFormField(
    //                     controller: _emailController,
    //                     autofillHints: [AutofillHints.email],
    //                     decoration: InputDecoration(
    //                       border: OutlineInputBorder(
    //                         borderRadius: BorderRadius.circular(15.0),
    //                       ),
    //                       filled: true,
    //                       fillColor: Colors.green[100],
    //                       labelText: 'Email',
    //                       hintText: 'edu.tr uzantılı adresinizi giriniz',
    //                     ),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.only(
    //                       left: 15.0, right: 15.0, top: 15, bottom: 15),
    //                   child: TextFormField(
    //                     controller: _passwordController,
    //                     obscureText: true,
    //                     decoration: InputDecoration(
    //                       border: OutlineInputBorder(
    //                         borderRadius: BorderRadius.circular(15.0),
    //                       ),
    //                       filled: true,
    //                       fillColor: Colors.green[100],
    //                       labelText: 'Şifre',
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   height: 50,
    //                   width: 250,
    //                   decoration: BoxDecoration(
    //                       color: Colors.amberAccent,
    //                       borderRadius: BorderRadius.circular(20)),
    //                   child: ElevatedButton(
    //                     onPressed: () {
    //                       if (_nameController.text != "" &&
    //                           _surnameController.text != "") {
    //                         _signUp();
    //                       }
    //                     },
    //                     child: Text(
    //                       'Kayıt Ol',
    //                       style: TextStyle(color: Colors.white, fontSize: 25),
    //                     ),
    //                     style: ButtonStyle(
    //                       backgroundColor:
    //                           MaterialStateProperty.resolveWith<Color?>(
    //                         (Set<MaterialState> states) {
    //                           if (states.contains(MaterialState.pressed)) {
    //                             // Color when the button is pressed
    //                             return Colors.amberAccent.withOpacity(
    //                                 0.5); // Adjust the opacity as needed
    //                           }
    //                           // Color for other states (e.g., normal)
    //                           return Colors.amberAccent;
    //                         },
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Column _loginPart() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            "assets/images/logo.jpeg",
            width: context.width * 0.5,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        UWTextFormField(
          labelText: LocaleKeys.emailFieldHint.translate,
          controller: _emailController,
        ),
        const SizedBox(
          height: 8,
        ),
        UWTextFormField(
          labelText: LocaleKeys.passwordFieldHint.translate,
          obscureText: true,
          controller: _passwordController,
        ),
        const SizedBox(
          height: 8,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
              onPressed: () {
                resetPassword();
              },
              child: Text(LocaleKeys.forgotPasswordButtonText.translate)),
        ),
        ElevatedButton(
            onPressed: () {
              _signIn();
            },
            child: Text(LocaleKeys.loginButtonText.translate)),
        const SizedBox(
          height: 8,
        ),
        TextButton(
            onPressed: () {
              setState(() {
                _tabController.animateTo(1);
              });
              // _signUp();
            },
            child: Text(LocaleKeys.signUpButtonText.translate)),
      ],
    );
  }

  void _signUp() async {
    String name = _nameController.text;
    String surname = _surnameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': name,
        'surname': surname,
        'email': email,
        // Diğer kullanıcı bilgilerini buraya ekleyebilirsiniz
      });
      print("User is successfully created");

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => VerifyEmailPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: Duration(seconds: 1),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign-Up Failed"),
            content: Text(
                "Varolan bir hesap ile kayıt olmaya çalıştınız ya da internet bağlantısı yok. Tekrar deneyiniz."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      _emailController.text = "";
      _passwordController.text = "";
    }
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      print("User is successfully Signed In");
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: Duration(seconds: 1),
        ),
      );
    } else {
      // Display an alert indicating that the sign-in attempt failed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign-In Failed"),
            content: Text("Invalid email or password. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      // Clear the text fields
      _emailController.text = "";
      _passwordController.text = "";
    }
  }

  Future resetPassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Şifre yenileme linki gönderildi'),
      ),
    );
  }

  _registerPart() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UWTextFormField(
          controller: _nameController,
          autofillHints: [AutofillHints.name],
          labelText: LocaleKeys.nameFieldHint.translate,
        ),
        const SizedBox(
          height: 8,
        ),
        UWTextFormField(
          controller: _surnameController,
          autofillHints: [AutofillHints.name],
          labelText: LocaleKeys.surnameFieldHint.translate,
        ),
        const SizedBox(
          height: 8,
        ),
        UWTextFormField(
          controller: _emailController,
          autofillHints: [AutofillHints.email],
          labelText: LocaleKeys.emailFieldHint.translate,
        ),
        const SizedBox(
          height: 8,
        ),
        UWTextFormField(
          controller: _passwordController,
          autofillHints: [AutofillHints.password],
          obscureText: true,
          labelText: LocaleKeys.passwordFieldHint.translate,
        ),
        const SizedBox(
          height: 8,
        ),
        ElevatedButton(
          onPressed: () {
            _signUp();
          },
          child: Text(LocaleKeys.signUpButtonText.translate),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(LocaleKeys.alreadyHaveAccountText.translate,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black,
                    )),
            TextButton(
                onPressed: () {
                  setState(() {
                    _tabController.animateTo(0);
                  });
                },
                child: Text(LocaleKeys.loginButtonText.translate)),
          ],
        )
      ],
    );
  }
}
