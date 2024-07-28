// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, unused_local_variable, use_build_context_synchronously, unused_import, body_might_complete_normally_nullable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_n_one/auth/login.dart';
import 'package:project_n_one/components/components.dart';
import 'package:project_n_one/screens/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _signuppageState();
}

class _signuppageState extends State<SignUpPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    username.dispose();
    email.dispose();
    password.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  Form(
                    key: formstate,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              color: Color.fromARGB(255, 223, 218, 218),
                            ),
                            alignment: Alignment.center,
                            height: 80,
                            width: 80,
                            child: Image.asset(
                              "assets/images/logo.png",
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Enter Your Personal Information",
                          style: TextStyle(
                              color: Color.fromARGB(255, 128, 127, 127)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Username',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        defaultTextFormField(
                            hintText: 'Enter Your UserName',
                            mycontroller: username,
                            validator: (val) {
                              if (val == "") {
                                return "The Form Is Empty";
                              }
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Email',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        defaultTextFormField(
                            validator: (val) {
                              if (val == "") {
                                return "The Form Is Empty";
                              }
                            },
                            hintText: 'Enter Your Email',
                            mycontroller: email),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Password',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        defaultTextFormField(
                            validator: (val) {
                              if (val == "") {
                                return "The Form Is Empty";
                              }
                            },
                            hintText: 'Enter Your Password',
                            mycontroller: password),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          alignment: Alignment.topRight,
                          child: Text(
                            "Forget Password ?",
                            style: TextStyle(fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ),
                  defaultButton(
                      buttoncolor: Colors.red,
                      text: "SignUp",
                      onPressed: () async {
                        try {
                          isLoading = true;
                          setState(() {});
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );
                          isLoading = false;
                          setState(() {});

                          FirebaseAuth.instance.currentUser!
                              .sendEmailVerification();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        } on FirebaseAuthException catch (e) {
                          isLoading = false;
                          setState(() {});
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: "Error",
                              desc: 'The password provided is too weak.',
                            ).show();
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: "Error",
                              desc: 'The account already exists for that email',
                            ).show();
                          }
                        } catch (e) {
                          print(e);
                        }
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(" Have An Account ?"),
                      MaterialButton(
                        minWidth: 20,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Color.fromARGB(255, 201, 40, 28),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
