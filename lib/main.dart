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
  void initState() {
    super.initState();
    readData();
  }

  bool isLoading = true;
  Map<String, List<Map<String, String>>> racks = {};
  Future<void> readData() async {
    var url =
        "https://myinvent-44b8a-default-rtdb.firebaseio.com/" + "data.json";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((blogId, blogData) {
        final rack = blogData["rack"];
        final shelf = blogData["shelf"];
        final bin = blogData["bin"];

        if (!racks.containsKey(rack)) {
          racks[rack] = [];
        }
        racks[rack]?.add({"shelf": shelf, "bin": bin});
      });
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TATA',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("My inventory"),
        ),
        body: isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: racks.length,
                itemBuilder: (BuildContext context, int index) {
                  final rack = racks.keys.toList()[index];
                  final items = racks[rack]!;
                  return Card(
                    child: ExpansionTile(
                      title: Text("Rack: $rack"),
                      children: items
                          .map(
                            (item) => ListTile(
                              title: Text("Shelf: ${item['shelf']}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Bin: ${item['bin']}"),
                                  Text("Part Number: ${item['partnumber']}"),
                                  Text("Part Name: ${item['partname']}"),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
