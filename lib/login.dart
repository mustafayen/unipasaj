import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unipasaj/firebase_auth/auth_services.dart';
import 'package:unipasaj/home.dart';

class LoggedInWidget extends StatefulWidget {
  @override
  State<LoggedInWidget> createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget>
    with SingleTickerProviderStateMixin {
  late TextEditingController t1 = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  final FirebaseAuthService _auth = FirebaseAuthService();

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
    return PopScope(
      canPop: true,
      onPopInvoked : (didPop){
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(text: "Giriş Yap"),
              Tab(text: "Kayıt Ol"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Text('ÜNİPASAJ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0), // Set the border radius
                          ),
                          filled: true,
                          fillColor: Colors.blue[100], // Set your desired background color here
                          labelText: 'Email',
                          hintText: 'edu.tr uzantılı adresinizi giriniz',
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 15),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0), // Set the border radius
                          ),
                          labelText: 'Şifre',
                          filled: true,
                          fillColor: Colors.blue[100],
                        ),
                      ),
                    ),

                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                        onPressed: _signIn,
                        child: Text(
                          'Giriş',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                // Color when the button is pressed
                                return Colors.amberAccent.withOpacity(0.5); // Adjust the opacity as needed
                              }
                              // Color for other states (e.g., normal)
                              return Colors.amberAccent;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _nameController,
                        autofillHints: [AutofillHints.name],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0), // Set the border radius
                          ),
                          filled: true,
                          fillColor: Colors.green[100], // Set your desired background color here
                          labelText: "İsim",
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
                      child: TextFormField(
                        controller: _surnameController,
                        autofillHints: [AutofillHints.name],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0), // Set the border radius
                          ),
                          filled: true,
                          fillColor: Colors.green[100], // Set your desired background color here
                          labelText: "Soyisim",
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
                      child: TextFormField(
                        controller: _emailController,
                        autofillHints: [AutofillHints.email],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          filled: true,
                          fillColor: Colors.green[100],
                          labelText: 'Email',
                          hintText: 'edu.tr uzantılı adresinizi giriniz',
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 15),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          filled: true,
                          fillColor: Colors.green[100],
                          labelText: 'Şifre',
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_nameController.text !="" && _surnameController.text !="") {
                            _signUp();
                          }},
                        child: Text(
                          'Kayıt Ol',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                // Color when the button is pressed
                                return Colors.amberAccent.withOpacity(0.5); // Adjust the opacity as needed
                              }
                              // Color for other states (e.g., normal)
                              return Colors.amberAccent;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signUp()async{
    String name= _nameController.text;
    String surname= _surnameController.text;
    String email= _emailController.text;
    String password= _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

   if(user!=null){

     await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
       'name': name,
       'surname': surname,
       'email': email,
       // Diğer kullanıcı bilgilerini buraya ekleyebilirsiniz
     });

      print("User is successfully created");

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
              MyHomePage(user: user),
          transitionsBuilder: (context, animation,
              secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
                position: offsetAnimation, child: child);
          },
          transitionDuration: Duration(
              seconds:
              1), // Set the duration here (1 second in this example)
        ),
      );

    }
    else{
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: Text("Sign-Up Failed"),
           content: Text("Varolan bir hesap ile kayıt olmaya çalıştınız ya da internet bağlantısı yok. Tekrar deneyiniz."),
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
          pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(user: user),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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


}