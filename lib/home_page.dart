import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speech = SpeechToText();
  final Map<String, HighlightedWord> _highlightWords = _getHighlightedWords();

  bool _isListening = false;
  String _text = 'Press the button and start speaking.';
  double _confidence = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title:
              Text('Confidence: ${(_confidence * 100).toStringAsFixed(1)}%')),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding:
              const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 150),
          child: TextHighlight(
            text: _text,
            words: _highlightWords,
            textStyle: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 64.0,
        duration: const Duration(milliseconds: 1000),
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        child: FloatingActionButton(
          tooltip: 'Listen',
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          onPressed: _listen,
        ),
      ),
    );
  }

  static Map<String, HighlightedWord> _getHighlightedWords() {
    final Map<String, HighlightedWord> words = <String, HighlightedWord>{};

    words.addAll(<String, HighlightedWord>{
      'hello': HighlightedWord(
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
        onTap: () => dev.log('hello'),
      ),
      'world': HighlightedWord(
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
        onTap: () => dev.log('world'),
      ),
    });

    return words;
  }

  Future<void> _listen() async {
    if (_isListening) {
      final bool available = await _speech.initialize(
        onStatus: (String status) => dev.log('onStatus: $status'),
        onError: (SpeechRecognitionError error) => dev.log('onError: $error'),
      );

      if (available) {
        setState(() => _isListening = true);

        _speech.listen(
          onResult: (SpeechRecognitionResult result) => setState(() {
            _text = result.recognizedWords;

            _confidence =
                result.hasConfidenceRating && !result.confidence.isNegative
                    ? result.confidence
                    : 0;
          }),
        );
      }
    } else {
      _speech.stop();

      setState(() => _isListening = false);
    }
  }
}
