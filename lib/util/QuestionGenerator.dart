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
    Question(
      text: 'Which of the following is a correct way to declare a multidimensional array in Java?',
      options: QuestionOption(items: [
        'a) int[] arr;',
        'b) int arr[[]];',
        'c) int[][]arr;',
        'd) int[[]] arr;'
      ], answer: 'c'),
    ),
    Question(
      text: 'When does the ArrayIndexOutOfBoundsException occur?',
      options: QuestionOption(items: [
        'a) Compile-time',
        'b) Run-time',
        'c) Not an error',
        'd) Not an exception at all'
      ], answer: 'b'),
    ),
  ];

  String iAmDoneText = 'Well done on completing the test! Check out your score below:';

  String getQuestion(int questionNumber) {
    if(questionNumber >= questionBank.length){
      return iAmDoneText;
    }
    return questionBank[questionNumber].text;
  }

  List<String> getOptions(int questionNumber) {
    if(questionNumber < questionBank.length){
      return questionBank[questionNumber].options.items;
    }
  }

  String getAnswer(int questionNumber) {
    return questionBank[questionNumber].options.answer;
  }
}
