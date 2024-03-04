
import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import 'package:final_project/home_screen.dart';
import 'package:final_project/entry_screen.dart';
import 'package:final_project/quiz_screen.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => const HomeScreen(),
      '/chat': (context) => const OpenAIEntryScreen(),
      '/quiz': (context) => const QuizScreen(),
    },
  ));
}
