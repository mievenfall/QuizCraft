import 'package:flutter/material.dart';
import '../services/response_process.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<int> selectedOptions = [];
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final List<Quiz> quizzes =
    ModalRoute.of(context)!.settings.arguments as List<Quiz>;
    selectedOptions = List.filled(quizzes.length, -1); // Initialize with -1 (no option selected)
  }

  @override
  Widget build(BuildContext context) {
    final List<Quiz> quizzes =
    ModalRoute.of(context)!.settings.arguments as List<Quiz>;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: quizzes.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.deepPurple[200],
                    margin: const EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quizzes[index].question,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(height: 16.0), // Add space between question and options
                          ...quizzes[index].options.asMap().entries.map(
                                (entry) {
                              int optionIndex = entry.key;
                              String option = entry.value;

                              return RadioListTile(
                                title: Text(
                                  option,
                                  style: TextStyle(fontSize: 18),
                                ),
                                value: optionIndex,
                                groupValue: selectedOptions[index],
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedOptions[index] = value ?? -1;
                                  });
                                },
                              );
                            },
                          ).toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: _currentIndex == 0
                        ? null
                        : () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  Text(
                    'Question ${_currentIndex + 1} of ${quizzes.length}',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    color: Colors.white,
                    onPressed: _currentIndex == quizzes.length - 1
                        ? null
                        : () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}