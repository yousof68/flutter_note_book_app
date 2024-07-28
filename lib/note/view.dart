// prefer_const_constructors, unused_element, unused_import

// ignore_for_file: unused_import

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_n_one/auth/login.dart';
import 'package:project_n_one/categories/add.dart';
import 'package:project_n_one/categories/edit.dart';
import 'package:project_n_one/note/add.dart';
import 'package:project_n_one/note/edit.dart';
import 'package:project_n_one/screens/home_page.dart';

class NoteView extends StatefulWidget {
  final String categoryid;
  const NoteView({super.key, required this.categoryid});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryid)
        .collection("note")
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
          title: Text('Note'),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddNote(
                docid: widget.categoryid,
              );
            }));
          },
          child: Icon(Icons.add),
        ),
        body: WillPopScope(
            child: isLoading
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
                        onLongPress: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            title: "Error",
                            desc: 'Are You Sure To Delete',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () async {
                              await FirebaseFirestore.instance
                                  .collection("categories")
                                  .doc(widget.categoryid)
                                  .collection("note")
                                  .doc(data[i].id)
                                  .delete();
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return NoteView(categoryid: widget.categoryid);
                              }));
                            },
                          ).show();
                        },
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return EditNote(
                                notedocid: data[i].id,
                                categorydocid: widget.categoryid,
                                value: data[i]["note"]);
                          }));
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [Text('${data[i]["note"]}')],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            onWillPop: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
                  return HomePage();
                }),
                (route) => false,
              );
              return Future.value(false);
            }));
  }
}
