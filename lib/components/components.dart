// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

Widget defaultTextFormField(
        {int maxlines = 1,
        required String hintText,
        required TextEditingController mycontroller,
        required String? Function(String?)? validator}) =>
    TextFormField(
      maxLines: maxlines,
      validator: validator,
      controller: mycontroller,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 14, color: Color.fromARGB(255, 134, 134, 134)),
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: Colors.grey))),
    );

Widget defaulteditTextFormField(
        {int maxlines = 15,
        required String hintText,
        required TextEditingController mycontroller,
        required String? Function(String?)? validator}) =>
    TextFormField(
      maxLines: maxlines,
      validator: validator,
      controller: mycontroller,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 14, color: Color.fromARGB(255, 134, 134, 134)),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey))),
    );

Widget defaultButton(
        {required void Function()? onPressed,
        required String text,
        required Color buttoncolor}) =>
    MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        height: 50,
        color: buttoncolor,
        textColor: Colors.white,
        onPressed: onPressed,
        child: Text(text));

Widget defaultImage() => Center(
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
    );
