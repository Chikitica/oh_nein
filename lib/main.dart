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
          title: Text('OH NEIN!'),
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
  int _points = 0;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _nouns = _loadNouns();
    _showNewNoun();
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
      setState(() {
        _points++;
        _showNewNoun();
      });
      message = 'Correct!';
    } else {
      String answer = '${_currentNoun.articleSingular} ${_currentNoun.singular}';
      message = 'Oh nein! is $answer';
      setState(() {
        _showNewNoun();
      });
    }

    _attempts++;

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
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // USA Flag above the English text
            Image.asset(
              'img/usa_flag.png', // Ensure you have this image in assets
              height: 50,
              width: 50,
            ),
            FutureBuilder(
              future: _nouns,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Noun>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading data');
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentNoun.english,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      const SizedBox(height: 10),
                      // German Flag above the German text
                      Image.asset(
                        'img/german_flag.png',
                        // Ensure you have this image in assets
                        height: 50,
                        width: 50,
                      ),
                      Text(
                        _currentNoun.singular,
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
                  // "Der" Button - Black
                  ElevatedButton(
                    onPressed: () {
                      _checkArticle('Der');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text('Der', style: TextStyle(color: Colors.white)),
                  ),
                  // "Die" Button - Red
                  ElevatedButton(
                    onPressed: () {
                      _checkArticle('Die');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Die', style: TextStyle(color: Colors.white)),
                  ),
                  // "Das" Button - Gold
                  ElevatedButton(
                    onPressed: () {
                      _checkArticle('Das');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: const Text('Das', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Text(
            'Points: $_points of $_attempts',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
