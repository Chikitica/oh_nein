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
        body: NounDisplay(),
      ),
    );
  }
}
class NounDisplay extends StatefulWidget {
  @override
  _NounDisplayState createState() => _NounDisplayState();
}

class _NounDisplayState extends State<NounDisplay> {
  late Future<List<Noun>> _nouns;
  late Noun _currentNoun;

  @override
  void initState() {
    super.initState();
    _nouns = _loadNouns();
    _currentNoun = Noun(
      id: '',
      english: '',
      articleSingular: '',
      singular: '',
      articlePlural: '',
      plural: '',
    );
  }

  Future<List<Noun>> _loadNouns() async {
    String data = await rootBundle.loadString('texts/nouns_list.json');
    List<dynamic> jsonList = json.decode(data);
    return jsonList.map((item) => Noun.fromJson(item)).toList();
  }

  void _showNewNoun() {
    final random = Random();
    _nouns.then((nouns) {
      setState(() {
        _currentNoun = nouns[random.nextInt(nouns.length)];
      });
    });
  }

  void _checkArticle(String article) {
    String message;
    if (_currentNoun.articleSingular.toLowerCase() == article.toLowerCase()) {
      message = 'Correct!';
    } else {
      message = 'Oh nein!';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Result'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder(
          future: _nouns,
          builder: (BuildContext context, AsyncSnapshot<List<Noun>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error loading data');
            } else {
              // final List<Noun> nouns = snapshot.data ?? [];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'English: ${_currentNoun.english}',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Singular: ${_currentNoun.singular}',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                ],
              );
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _checkArticle('Der');
                },
                child: const Text('Der'),
              ),
              ElevatedButton(
                onPressed: () {
                  _checkArticle('Die');
                },
                child: const Text('Die'),
              ),
              ElevatedButton(
                onPressed: () {
                  _checkArticle('Das');
                },
                child: const Text('Das'),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: _showNewNoun,
          child: const Text('Next Noun'),
        ),
      ],
    );
  }
}

