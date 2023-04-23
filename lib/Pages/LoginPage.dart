import 'package:chatapp/Pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../decoration.dart';
import 'CompleteProfile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailControler = TextEditingController();
  TextEditingController passwordControler = TextEditingController();

  checkValues() {
    String email = emailControler.text.trim();
    String password = passwordControler.text.trim();

    if (email == "" || password == "") {
      print('Fill All the Fields For Login');
    } else {
      print('Everything Fine for Login');
    }
    SignIn(email, password).then((value) {
      if (value != null) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const HomePage();
          },
        ));
      }
    });
  }

  Future<UserCredential?> SignIn(String email, String password) async {
    UserCredential? credential;
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e.toString());
    }
    return credential;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login Page',
                      style: TextStyle(
                        color: slfontColor,
                        fontWeight: FontWeight.w900,
                        fontSize: slPagefontsize,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                allTextFields(name: "EmailAddress", controller: emailControler),
                const SizedBox(height: 10),
                allTextFields(name: 'Password', controller: passwordControler),
                const SizedBox(height: 10),
                CupertinoButton(
                  onPressed: () {
                    checkValues();
                  },
                  color: Colors.black26,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t Have an Account?'),
                    MaterialButton(
                      child: const Text('Sign Up'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class allTextFields extends StatelessWidget {
  TextEditingController controller;
  String name;

  allTextFields({super.key, required this.name, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: name,
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
          autofocus: true,
        ),
      ),
    );
  }
}
