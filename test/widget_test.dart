import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:oh_nein/main.dart';
import 'package:oh_nein/Noun.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NounDisplay Widget Tests', () {
    late List<Noun> testNouns;
    setUp(() async {
      // Updated mock noun data to match the new structure
      const String nounData = '''
  [
    {
      "id": "1",
      "english": "Apple",
      "article_singular": "Der",
      "singular": "Apfel",
      "article_plural": "Die",
      "plural": "Äpfel"
    },
    {
      "id": "2",
      "english": "Banana",
      "article_singular": "Die",
      "singular": "Banane",
      "article_plural": "Die",
      "plural": "Bananen"
    },
    {
      "id": "3",
      "english": "Hand",
      "article_singular": "Die",
      "singular": "Hand",
      "article_plural": "Die",
      "plural": "Hände"
    }
  ]
  ''';

      // Decode the JSON and create Noun instances
      final List<dynamic> jsonList = json.decode(nounData);
      testNouns = jsonList.map((item) => Noun.fromJson(item)).toList();

      // Mock the loading of the JSON data in the app
      const MethodChannel('flutter/services')
          .setMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == '_loadNouns') {
          return nounData;
        }
        return null;
      });
    });

    testWidgets('Displays nouns and responds to correct and incorrect answers',
        (WidgetTester tester) async {
      // Load the widget tree for testing
      await tester.pumpWidget(MaterialApp(home: NounDisplay()));

      // Check if the FutureBuilder is initially waiting
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for FutureBuilder to complete
      await tester.pump();

      // Check if a noun is displayed
      expect(find.text('apple'), findsOneWidget);
      expect(find.text('Apfel'), findsOneWidget);

      // Press the correct article button (Der for Apfel)
      await tester.tap(find.text('Der'));
      await tester.pump();

      // Check if the result dialog is shown with the message 'Correct!'
      expect(find.text('Correct!'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pump();

      // Check if a new noun is displayed after answering
      expect(find.text('banana'), findsOneWidget);
      expect(find.text('Banane'), findsOneWidget);

      // Press an incorrect article button (Der for Banane)
      await tester.tap(find.text('Der'));
      await tester.pump();

      // Check if the result dialog is shown with the message 'Oh nein!'
      expect(find.text('Oh nein!'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pump();

      // Verify points and attempts display
      expect(find.text('Points: 1 of 2'), findsOneWidget);
    });
  });
}
