import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stepper_touch/stepper_touch.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF6D72FF),
        ),
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StepperTouch(
                  initialValue: 0,
                  direction: Axis.vertical,
                  withSpring: false,
                  onChanged: (int value) => print('new value $value'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StepperTouch(
                  initialValue: 0,
                  onChanged: (int value) => print('new value $value'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
