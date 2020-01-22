import 'package:quizzler/model/QuestionOptions.dart';

class Question {
  String text;
  QuestionOption options;

  Question({String text, QuestionOption options}) {
    this.text = text;
    this.options = options;
  }
}
