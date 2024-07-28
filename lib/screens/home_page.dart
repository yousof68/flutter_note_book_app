// prefer_const_constructors, unused_element, unused_import

// ignore_for_file: unused_import

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_n_one/auth/login.dart';
import 'package:project_n_one/categories/add.dart';
import 'package:project_n_one/categories/edit.dart';
import 'package:project_n_one/note/view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HomePage'),
          actions: [
            IconButton(
                onPressed: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.disconnect();
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route) => false);
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddCategory();
            }));
          },
          child: Icon(Icons.add),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.all(10),
                child: GridView.builder(
                  itemCount: data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: 180),
                  itemBuilder: (context, i) => InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return NoteView(categoryid: data[i].id);
                      }));
                    },
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: "Error",
                        desc: 'Are You Sure To Delete',
                        btnCancelText: "Delete",
                        btnOkText: "Edit",
                        btnCancelOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection("categories")
                              .doc(data[i].id)
                              .delete();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return HomePage();
                          }));
                        },
                        btnOkOnPress: () async {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return EditCategory(
                                docid: data[i].id, oldname: data[i]["name"]);
                          }));
                        },
                      ).show();
                    },
                    child: Card(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/oipp.png",
                              height: 100,
                            ),
                            Text('${data[i]["name"]}')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ));
  }
}
