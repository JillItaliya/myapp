import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _form = GlobalKey<FormState>();
  late String rack;
  late String shelf;
  late String bin;
  void writeData() async {
    _form.currentState?.save();

    // Please replace the Database URL
    // which we will get in “Add Realtime
    // Database” step with DatabaseURL
    var url =
        "https://myinvent-44b8a-default-rtdb.firebaseio.com/" + "data.json";

    // (Do not remove “data.json”,keep it as it is)
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({"rack": rack, "shelf": shelf, "bin": bin}),
      );
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RealTime Database',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("GeeksforGeeks"),
        ),
        body: Form(
          key: _form,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Rack"),
                  onSaved: (value) {
                    rack = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "shelf"),
                  onSaved: (value) {
                    shelf = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "bins"),
                  onSaved: (value) {
                    bin = value!;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: writeData,
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
