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
bool _showExitButton = false;
bool _shownGrade = false;
bool _showTimer = true;
String askQuestion = 'What would you like to do?';
int _start = 10;
int _current = 10;

QuestionGenerator _questionGenerator = new QuestionGenerator();
int _overAllScore= _questionGenerator.questionBank.length * 2;

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

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() { _current = _start - duration.elapsed.inSeconds; });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
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
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
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
              child: Column(
                children: <Widget>[
                  RadioListTile(
                    title: Text(
                      _questionNumber >= _questionGenerator.questionBank.length ? '' : _questionGenerator.getOptions(_questionNumber)[0],
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                      ),
                    ),
                    value:  _questionNumber >= _questionGenerator.questionBank.length ? '' : _questionGenerator.getOptions(_questionNumber)[0],
                    groupValue: _groupValue,
                    onChanged: (String value) {
                      setState(() {
                        _groupValue = value;
                        _selectedAnswer = value.split(")")[0];
                      });
                    },
                  ),
                  RadioListTile(
                      title: Text(
                        _questionNumber >= _questionGenerator.questionBank.length ? '' : _questionGenerator.getOptions(_questionNumber)[1],
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                      value: _questionNumber >= _questionGenerator.questionBank.length ? '' : _questionGenerator.getOptions(_questionNumber)[1],
                      groupValue: _groupValue,
                      onChanged: (String value) {
                        setState(() {
                          _groupValue = value;
                          _selectedAnswer = value.split(")")[0];
                        });
                      }),
                  RadioListTile(
                      title: Text(
                        _questionNumber >= _questionGenerator.questionBank.length ? '' : _questionGenerator.getOptions(_questionNumber)[2],
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                      value: _questionNumber >= _questionGenerator.questionBank.length ? '' : _questionGenerator.getOptions(_questionNumber)[2],
                      groupValue: _groupValue,
                      onChanged: (String value) {
                        setState(() {
                          _groupValue = value;
                          _selectedAnswer = value.split(")")[0];
                        });
                      }),
                  RadioListTile(
                      title: Text(
                        _questionNumber >= _questionGenerator.questionBank.length ? '' : _questionGenerator.getOptions(_questionNumber)[3],
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                      value: _questionNumber >= _questionGenerator.questionBank.length ? '' : _questionGenerator.getOptions(_questionNumber)[3],
                      groupValue: _groupValue,
                      onChanged: (String value) {
                        setState(() {
                          _groupValue = value;
                          _selectedAnswer = value.split(")")[0];
                        });
                      }),
                ],
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
                    '$_score/$_overAllScore',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: !_showExitButton,
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
                      _lastQuestion ? 'Finish' : 'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    _correctAnswer =
                        _questionGenerator.getAnswer(_questionNumber);
                    if (_selectedAnswer == _correctAnswer) {
                      _score += 2;
                    }
                    if (_questionNumber <=
                        _questionGenerator.questionBank.length - 1) {
                      _questionNumber++;
                    }
                    if (_questionNumber ==
                        _questionGenerator.questionBank.length - 1) {
                      _lastQuestion = true;
                    }
                    if (_questionNumber >
                        _questionGenerator.questionBank.length - 1) {
                      _showGrade = true;
                      _showOptions = false;
                      _showExitButton = true;
                      _showTimer = false;
                    }
                  });
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: _showExitButton,
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
                      'Good bye!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  exit(0);
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
