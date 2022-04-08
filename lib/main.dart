import 'package:flutter/material.dart';

import 'package:flutter_speech_to_text/home_page.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Speech to Text',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const HomePage(title: 'Flutter Speech to Text'),
    );
  }
}
