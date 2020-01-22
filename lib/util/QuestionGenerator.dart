import 'package:quizzler/model/Question.dart';
import 'package:quizzler/model/QuestionOptions.dart';

class QuestionGenerator {
  List<Question> questionBank = [
    Question(
      text: 'Which of these best describes an array?',
      options: QuestionOption(items: [
        'a) A data structure that shows a hierarchical behaviour',
        'b) Container of objects of similar types',
        'c) Arrays are immutable once initialised',
        'd) Array is not a data structure'
      ], answer: 'b'),
    ),
    Question(
      text: 'How do you initialize an array in C?',
      options: QuestionOption(items: [
        'a) int arr[3] = (1,2,3);',
        'b) int arr(3) = {1,2,3};',
        'c) int arr[3] = {1,2,3};',
        'd) int arr(3) = (1,2,3);'
      ], answer: 'c'),
    ),
    Question(
      text: 'How do you instantiate an array in Java?',
      options: QuestionOption(items: [
        'a) int arr[] = new int(3);',
        'b) int arr[];',
        'c) int arr[] = new int[3];',
        'd) int arr() = new int(3);'
      ], answer: 'c'),
    ),
  ];

  String getQuestion(int questionNumber) {
    return questionBank[questionNumber].text;
  }

  List<String> getOptions(int questionNumber) {
    return questionBank[questionNumber].options.items;
  }

  String getAnswer(int questionNumber) {
    return questionBank[questionNumber].options.answer;
  }
}
