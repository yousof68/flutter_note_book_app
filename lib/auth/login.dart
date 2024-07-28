// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, body_might_complete_normally_nullable, unused_element, unused_import

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_n_one/auth/signup.dart';
import 'package:project_n_one/components/components.dart';
import 'package:project_n_one/screens/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginpageState();
}

class _LoginpageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  bool isLoading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    email.dispose();
    password.dispose();
  }

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
                          "Login",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Login To Continue Using The App",
                          style: TextStyle(
                              color: Color.fromARGB(255, 128, 127, 127)),
                        ),
                        SizedBox(
                          height: 20,
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
                        InkWell(
                          onTap: () async {
                            if (email.text == "") {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: "Error",
                                desc:
                                    'Please Put Your Email Then Tap On Forget Password',
                              ).show();
                              return;
                            }
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.rightSlide,
                                title: "Sent Password",
                                desc:
                                    'Please Reset Your Password We Sent You A Link To Your Email',
                              ).show();
                            } catch (e) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: "Error",
                                desc:
                                    'Please Put Real Email In The Form And Try Again',
                              ).show();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10, bottom: 20),
                            alignment: Alignment.topRight,
                            child: Text(
                              "Forget Password ?",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  defaultButton(
                      buttoncolor: Colors.red,
                      text: "Login",
                      onPressed: () async {
                        if (formstate.currentState!.validate()) {
                          try {
                            isLoading = true;
                            setState(() {});
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email.text, password: password.text);
                            isLoading = false;
                            setState(() {});
                            if (credential.user!.emailVerified) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (route) => false,
                              );
                            } else {
                              FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                                  return HomePage();
                                }),
                                (route) => false,
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            isLoading = false;
                            setState(() {});
                            if (e.code == 'user-not-found') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: "Error",
                                desc: 'No user found for that email',
                              ).show();

                              print('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: "Error",
                                desc: 'Wrong password provided for that user.',
                              ).show();
                            }
                          }
                        } else
                          (print("Not Validate"));
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  defaultButton(
                      buttoncolor: Color.fromARGB(255, 102, 96, 96),
                      text: "Login With Google",
                      onPressed: () async {
                        isLoading = true;
                        setState(() {});
                        await signInWithGoogle();
                        isLoading = true;
                        setState(() {});
                      }),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Dont Have An Account ?"),
                      MaterialButton(
                        minWidth: 20,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        },
                        child: Text(
                          'Register',
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
