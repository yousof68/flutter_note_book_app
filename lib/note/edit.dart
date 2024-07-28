// ignore_for_file: body_might_complete_normally_nullable, unused_local_variable, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_n_one/components/components.dart';
import 'package:project_n_one/note/view.dart';
import 'package:project_n_one/screens/home_page.dart';

class EditNote extends StatefulWidget {
  final String notedocid;
  final String categorydocid;
  final String value;
  const EditNote(
      {super.key,
      required this.notedocid,
      required this.categorydocid,
      required this.value});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  bool isLoading = false;

  editNote() async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categorydocid)
        .collection("note");
    if (formstate.currentState!.validate()) {
      bool isLoading = true;
      setState(() {});
      try {
        await collectionnote.doc(widget.notedocid).update({
          "note": note.text,
        });

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return NoteView(
              categoryid: widget.categorydocid,
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
  void initState() {
    note.text = widget.value;
    super.initState();
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
        title: Text("Edit"),
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
                      text: 'Save',
                      onPressed: () {
                        editNote();
                      })
                ],
              ),
      ),
    );
  }
}
