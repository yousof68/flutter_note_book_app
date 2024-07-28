// ignore_for_file: body_might_complete_normally_nullable, unused_local_variable, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_n_one/components/components.dart';
import 'package:project_n_one/screens/home_page.dart';

class EditCategory extends StatefulWidget {
  final String docid;
  final String oldname;

  const EditCategory({super.key, required this.docid, required this.oldname});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  bool isLoading = false;

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  editCategory() async {
    if (formstate.currentState!.validate()) {
      bool isLoading = true;
      setState(() {});
      try {
        await categories.doc(widget.docid).update({"name": name.text});

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
            return HomePage();
          }),
          (route) => false,
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
    name.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.oldname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Category"),
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
                    child: defaultTextFormField(
                        hintText: "Enter Name",
                        mycontroller: name,
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
                        editCategory();
                      })
                ],
              ),
      ),
    );
  }
}
