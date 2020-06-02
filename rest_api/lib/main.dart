import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GET data from Internet (Example)",
      home: home()));
}

class home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return homeState();
  }
}

class homeState extends State<home> {
  Future<Album> futureAlbum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("GET data from Internet (Example)"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                  "An example to GET data from Internet using 'http' Dart package in flutter app."),
            ),
            Center(
              child: RaisedButton.icon(
                icon: Icon(Icons.cloud_download),
                label: Text("GET data"),
                onPressed: () {
                  futureAlbum = fetchAlbum();

                  internet();
                },
              ),
            )
          ],
        ));
  }

  void internet() {
    AlertDialog alertDialog = AlertDialog(
      elevation: 10,
      backgroundColor: Colors.white70,
      title: Icon(
        Icons.sync,
        size: 50,
        color: Colors.red,
      ),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  debugPrint("OK");
                  return Text(
                      "Data Received.\n\nID=${snapshot.data.id}\nUserID=${snapshot.data.userId}\ntitle=${snapshot.data.title}");
                } else if (snapshot.hasError) {
                  debugPrint("Network ERROR.");
                  return Text("Network ERROR. Try Again.");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ]),
    );
    showDialog(context: this.context, builder: (_) => alertDialog);
  }
}
