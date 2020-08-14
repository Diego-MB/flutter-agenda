import 'package:agenda/Home.dart';
import 'package:flutter/material.dart';
import 'package:asuka/asuka.dart' as asuka;

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
        //Acessar snackBar globalmente sem precisar usar globalkeys
        builder: asuka.builder
      ),
    );
