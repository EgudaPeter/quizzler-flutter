import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/async.dart';
import 'package:quizzler/util/QuestionGenerator.dart';

int _questionNumber = 0;
String _selectedAnswer = '';
String _correctAnswer = '';
String _groupValue = '';
int _score = 0;
bool _showOptions = true;
bool _showGrade = false;
bool _lastQuestion = false;
bool _showRestartButton = false;
bool _shownGrade = false;
bool _showTimer = true;
bool _hasUserSelectedAnOption = false;
bool _newQuestion = false;
String askQuestion = 'What would you like to do?';
int _start = 10;
int _current = 10;

StreamSubscription<CountdownTimer> _listener;

QuestionGenerator _questionGenerator = new QuestionGenerator();
int _overAllScore = _questionGenerator.questionBank.length * 2;

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Quizzler'),
          backgroundColor: Colors.black,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    CountdownTimer _countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    if (_newQuestion) {
      _listener.cancel();
    }

    _newQuestion = _newQuestion ? false : _newQuestion;

    _listener = _countDownTimer.listen(null);
    _listener.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
      });
    });

    _listener.onDone(() {
      setState(() {
        if (_hasUserSelectedAnOption) {
          _checkIfCorrectAnswerIsPicked();
        }
        _getNewQuestion();
        _checkIfLastQuestionIsBeingDisplayed();
        _checkIfUserHasGoneBeyondLastQuestionThenCancelListener();
      });
    });
  }

  List<Widget> generateRadioButtonsViaNumberOfOptionsAvailable(int number) {
    List<Widget> listOfRadioButtons = [];
    if (number >= _questionGenerator.questionBank.length) {
      return listOfRadioButtons;
    }
    for (int i = 0; i < _questionGenerator.getOptions(number).length; i++) {
      listOfRadioButtons.add(new RadioListTile(
        title: Text(
          _questionGenerator.getOptions(number)[i],
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.black,
          ),
        ),
        value: number >= _questionGenerator.questionBank.length
            ? ''
            : _questionGenerator.getOptions(number)[i],
        groupValue: _groupValue,
        onChanged: (String value) {
          setState(() {
            _hasUserSelectedAnOption = true;
            _groupValue = value;
            _selectedAnswer = value.split(")")[0];
          });
        },
      ));
    }
    return listOfRadioButtons;
  }

  int returnScoreInPercentage(int score) {
    var calculatedScore = (score / _overAllScore) * 100;
    return calculatedScore.floor();
  }

  void _checkIfCorrectAnswerIsPicked() {
    _correctAnswer = _questionGenerator.getAnswer(_questionNumber);
    if (_selectedAnswer == _correctAnswer) {
      _score += 2;
    }
  }

  void _getNewQuestion() {
    if (_questionNumber <= _questionGenerator.questionBank.length - 1) {
      _hasUserSelectedAnOption = false;
      _questionNumber++;
      _newQuestion = true;
      _start = _current = 10;
      _startTimer();
    }
  }

  void _checkIfLastQuestionIsBeingDisplayed() {
    if (_questionNumber == _questionGenerator.questionBank.length - 1) {
      _lastQuestion = true;
    }
  }

  void _checkIfUserHasGoneBeyondLastQuestion() {
    if (_questionNumber > _questionGenerator.questionBank.length - 1) {
      _showGrade = true;
      _showOptions = false;
      _showRestartButton = true;
      _showTimer = false;
    }
  }

  void _checkIfUserHasGoneBeyondLastQuestionThenCancelListener() {
    if (_questionNumber > _questionGenerator.questionBank.length - 1) {
      _showGrade = true;
      _showOptions = false;
      _showRestartButton = true;
      _showTimer = false;
      _listener.cancel();
    }
  }

  void _restartQuizzler() {
    _questionNumber = 0;
    _showGrade = false;
    _showOptions = true;
    _showRestartButton = false;
    _showTimer = true;
    _lastQuestion = false;
    _score = 0;
    _listener.cancel();
    _start = _current = 10;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Visibility(
          visible: _showTimer,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                '$_current',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
        Expanded(
          flex: _showGrade ? 1 : 2,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                Text(
                  _shownGrade
                      ? askQuestion
                      : _questionGenerator.getQuestion(_questionNumber),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _showOptions,
          child: Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: ListView(
                children: generateRadioButtonsViaNumberOfOptionsAvailable(
                    _questionNumber),
              ),
            ),
          ),
        ),
        Visibility(
          visible: _showGrade,
          child: Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    '${returnScoreInPercentage(_score)}%',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 35.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: !_showRestartButton,
          child: Container(
            height: 100.0,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _lastQuestion ? 'Finish' : 'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                onPressed: !_hasUserSelectedAnOption
                    ? null
                    : () {
                        setState(() {
                          _checkIfCorrectAnswerIsPicked();

                          _getNewQuestion();

                          _checkIfLastQuestionIsBeingDisplayed();

                          _checkIfUserHasGoneBeyondLastQuestion();
                        });
                      },
              ),
            ),
          ),
        ),
        Visibility(
          visible: _showRestartButton,
          child: Container(
            height: 100.0,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: FlatButton(
                textColor: Colors.white,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
//                    Icon(
//                      Icons.thumb_up,
//                      color: Colors.white,
//                      size: 20.0,
//                    ),
//                    SizedBox(
//                      width: 10.0,
//                    ),
                    Text(
                      'Restart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    _restartQuizzler();
                  });
                  //The user picked true.
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
