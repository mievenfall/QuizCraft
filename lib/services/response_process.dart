import 'package:flutter/material.dart';

import '../services/chat_service.dart';

class ResponseProcess {
  static Future<List<Quiz>> getQuizzes({
    required String prompt1,
    required String prompt2,
    required double numQuestions,
  }) async {
    String? response = await ChatService().request([
      prompt1,
      prompt2,
      numQuestions.toString()
    ]);

    return parseQuizzes(response!);
  }

  static List<Quiz> parseQuizzes(String text) {
    List<Quiz> quizzes = [];
    List<String> questions = [];
    List<List<String>> options = [];
    List<String> answers = [];
    int currentQuestion = -1;
    int currentAnswer = -1;
    bool isAnswerSection = false;

    text.split("\n").forEach((line) {
      if (line.startsWith("Question")) {
        currentQuestion++;
        String question = line.substring(line.indexOf(":") + 2).trim();
        questions.add(question);
        options.add([]);
        isAnswerSection = false;
      } else if (line.startsWith("Option")) {
        if (currentQuestion >= 0 && currentQuestion < options.length) {
          String option = line.substring(line.indexOf(":") + 2).trim();
          options[currentQuestion].add(option);
        }
      } else if (line.startsWith("Answer:")) {
        isAnswerSection = true;
        currentAnswer++;
        if (currentAnswer < answers.length) {
          answers[currentAnswer] = "";
        } else {
          answers.add("");
        }
      } else if (isAnswerSection) {
        if (currentAnswer >= 0 && currentAnswer < answers.length) {
          answers[currentAnswer] += line.trim() + "\n";
        }
      }
    });

    for (int i = 0; i < questions.length; i++) {
      String answer = "";
      if (i < answers.length) {
        answer = answers[i].trim();
      }
      Quiz quiz = Quiz(
        question: questions[i],
        options: options[i],
        answer: answer,
      );
      quizzes.add(quiz);
    }

    return quizzes;
  }
}

class Quiz {
  String question;
  List<String> options;
  String answer;

  Quiz({
    required this.question,
    required this.options,
    required this.answer,
  });
}