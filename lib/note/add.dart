// ignore_for_file: body_might_complete_normally_nullable, unused_local_variable, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_n_one/components/components.dart';
import 'package:project_n_one/note/view.dart';
import 'package:project_n_one/screens/home_page.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  bool isLoading = false;

  addNote() async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docid)
        .collection("note");
    if (formstate.currentState!.validate()) {
      bool isLoading = true;
      setState(() {});
      try {
        DocumentReference response = await collectionnote.add({
          "note": note.text,
        });

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return NoteView(
              categoryid: widget.docid,
            );
          }),
        );
      } catch (e) {
        bool isLoading = false;
        setState(() {});
        print("error $e");
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
      ),
      body: Form(
        key: formstate,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: defaulteditTextFormField(
                        hintText: "Enter Your Note",
                        mycontroller: note,
                        validator: (val) {
                          if (val == '') {
                            return "The Form Is Empty!";
                          }
                        }),
                  ),
                  defaultButton(
                      buttoncolor: Colors.red,
                      text: 'Add',
                      onPressed: () {
                        addNote();
                      })
                ],
              ),
      ),
    );
  }
}
