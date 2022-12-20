import 'package:flutter/material.dart';
import 'package:flutter_application_1/ex.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello World",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Gauss App"),
          backgroundColor: Color.fromARGB(224, 33, 117, 33),
        ),
        body: Center(
            child: Text(
          "Parece difícil. Mas é.",
        )),
      ),
    );
  }
}
