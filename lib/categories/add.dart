// ignore_for_file: body_might_complete_normally_nullable, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_n_one/components/components.dart';
import 'package:project_n_one/screens/home_page.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  bool isLoading = false;

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  addCategory() async {
    if (formstate.currentState!.validate()) {
      bool isLoading = true;
      setState(() {});
      try {
        DocumentReference response = await categories.add(
            {"name": name.text, "id": FirebaseAuth.instance.currentUser!.uid});

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
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
                      text: 'Add',
                      onPressed: () {
                        addCategory();
                      })
                ],
              ),
      ),
    );
  }
}
