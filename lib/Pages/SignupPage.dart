import 'package:chatapp/Pages/CompleteProfile.dart';
import 'package:chatapp/Pages/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailControler = TextEditingController();
  TextEditingController passwordControler = TextEditingController();
  TextEditingController compasswordControler = TextEditingController();

  checkValues() {
    String email = emailControler.text.trim();
    String password = passwordControler.text.trim();
    String compassword = compasswordControler.text.trim();
    if (email == "" || password == "" || compassword == "") {
      print('Fill All the Fields For SignUp');
    }
    if (password != compassword) {
      print('Password Doesnot Match for SignUp');
    } else {
      print('Everything Fine for SignUp');
    }
    SignUp(email, password).then((value) {
      if (value != null) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const CompleteProfile();
          },
        ));
      }
    });
  }

  Future<UserCredential?> SignUp(String email, String password) async {
    UserCredential? credential;
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      credential = await auth.createUserWithEmailAndPassword(
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
                      'Signup Page',
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
                allTextFields(
                    name: 'Confirm Password', controller: compasswordControler),
                const SizedBox(height: 10),
                CupertinoButton(
                  onPressed: () {
                    checkValues();
                  },
                  color: Colors.black26,
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Have an Account?'),
                    MaterialButton(
                      child: const Text('Sign In'),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return LoginPage();
                          },
                        ));
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
