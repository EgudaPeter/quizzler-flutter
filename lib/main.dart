import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizzler/util/QuestionGenerator.dart';

int _questionNumber = 0;
String _selectedAnswer = '';
String _groupValue = '';
List<int> _scoreKeeper = [];
bool _showOptions = true;
bool _showGrade = false;
bool _lastQuestion = false;
bool _showRestartButton = false;
bool _shownGrade = false;
String askQuestion = 'What would you like to do?';

QuestionGenerator _questionGenerator = new QuestionGenerator();

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
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Text(
              '10s',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic),
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
                  _shownGrade ? askQuestion : _questionGenerator.getQuestion(_questionNumber),
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
                      _questionGenerator.getOptions(_questionNumber)[0],
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                      ),
                    ),
                    value: _questionGenerator.getOptions(_questionNumber)[0],
                    groupValue: _groupValue,
                    onChanged: (String value) {
                      setState(() {
                        _groupValue = value;
                      });
                    },
                  ),
                  RadioListTile(
                      title: Text(
                        _questionGenerator.getOptions(_questionNumber)[1],
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                      value: _questionGenerator.getOptions(_questionNumber)[1],
                      groupValue: _groupValue,
                      onChanged: (String value) {
                        setState(() {
                          _groupValue = value;
                        });
                      }),
                  RadioListTile(
                      title: Text(
                        _questionGenerator.getOptions(_questionNumber)[2],
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                      value: _questionGenerator.getOptions(_questionNumber)[2],
                      groupValue: _groupValue,
                      onChanged: (String value) {
                        setState(() {
                          _groupValue = value;
                        });
                      }),
                  RadioListTile(
                      title: Text(
                        _questionGenerator.getOptions(_questionNumber)[3],
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                      value: _questionGenerator.getOptions(_questionNumber)[3],
                      groupValue: _groupValue,
                      onChanged: (String value) {
                        setState(() {
                          _groupValue = value;
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
                    'This is your grade',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.black,
                    ),
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
              child: FlatButton(
                textColor: Colors.white,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.thumb_up,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
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
                    if (_questionNumber <
                        _questionGenerator.questionBank.length - 1) {
                      _questionNumber++;
                    } else {
                      _questionNumber = 0;
                    }
                    if (_questionNumber ==
                        _questionGenerator.questionBank.length - 1) {
                      _lastQuestion = true;
                    }
                    if (_questionNumber >
                        _questionGenerator.questionBank.length - 1) {
                      _showGrade = true;
                      _showOptions = false;
                    }
                  });
                  //The user picked true.
                },
              ),
            ),
          ),
        ),
//        Visibility(
//          visible: _showRestartButton,
//          child: Container(
//            height: 100.0,
//            child: Padding(
//              padding: EdgeInsets.all(15.0),
//              child: FlatButton(
//                textColor: Colors.white,
//                color: Colors.black,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Icon(
//                      Icons.thumb_up,
//                      color: Colors.white,
//                      size: 20.0,
//                    ),
//                    SizedBox(
//                      width: 10.0,
//                    ),
//                    Text(
//                      _lastQuestion ? 'Finish' : 'Submit',
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 20.0,
//                      ),
//                    ),
//                  ],
//                ),
//                onPressed: () {
//                  setState(() {
//                    if (_questionNumber <
//                        _questionGenerator.questionBank.length - 1) {
//                      _questionNumber++;
//                    } else {
//                      _questionNumber = 0;
//                    }
//                    if (_questionNumber ==
//                        _questionGenerator.questionBank.length - 1) {
//                      _lastQuestion = true;
//                    }
//                    if (_questionNumber >
//                        _questionGenerator.questionBank.length - 1) {
//                      _showGrade = true;
//                      _showOptions = false;
//                    }
//                  });
//                  //The user picked true.
//                },
//              ),
//            ),
//          ),
//        ),
      ],
    );
  }
}
