import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Noun.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Random Singular Noun'),
        ),
        body: Center(
          child: FutureBuilder(
            future: _loadNouns(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Noun>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error loading data');
              } else {
                final List<Noun> nouns = snapshot.data ?? [];
                final random = Random();
                final randomNoun = nouns[random.nextInt(nouns.length - 1)];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Singular: ${randomNoun.singular}',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Plural: ${randomNoun.plural}',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'English: ${randomNoun.english}',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<List<Noun>> _loadNouns() async {
    String data = await rootBundle.loadString('texts/nouns_list.json');
    List<dynamic> jsonList = json.decode(data);
    return jsonList.map((item) => Noun.fromJson(item)).toList();
  }
}
