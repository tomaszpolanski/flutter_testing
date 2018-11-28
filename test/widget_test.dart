// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/http.dart';
import 'package:flutter_testing/main.dart';
import 'package:http/http.dart' as http;

import 'unit_test.dart';

void main() {
  testWidgets('Display user', (WidgetTester tester) async {
    final get = (String url) {
      if (url.contains('/users/')) {
        return Future.value(http.Response(userResponse, 200));
      } else {
        return Future.value(http.Response('[]', 200));
      }
    };

    await tester.pumpWidget(MaterialApp(home: ProfilePage(Http(get))));
    await tester.pump();

    //debugDumpApp();
    expect(find.text('John'), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(nameKey)).data, 'John');
  });

  testWidgets('Display repositories', (WidgetTester tester) async {
    final get = (String url) {
      if (url.contains('/users/')) {
        return Future.value(http.Response(userResponse, 200));
      } else {
        return Future.value(http.Response(repoResponse, 200));
      }
    };

    await tester.pumpWidget(MaterialApp(home: ProfilePage(Http(get))));
//    await tester.pump();
//    await tester.pump();
    //vs
    await tester.pumpAndSettle();

    expect(find.text('First'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(3));
    //debugDumpApp();
  });
}

const repoResponse = '''
[
    {
        "name": "First",
        "description": "First Description"
    },
    {
        "name": "Second",
        "description": "Second Description"
    },
    {
        "name": "Third",
        "description": "Third Description"
    }
]
''';
