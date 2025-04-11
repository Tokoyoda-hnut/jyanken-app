import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: JankenPage());
  }
}

class JankenPage extends StatefulWidget {
  const JankenPage({super.key});

  @override
  State<JankenPage> createState() => _JankenPageState();
}

class _JankenPageState extends State<JankenPage> {
  String computerHand = '✌️';
  String myHand = '✌️';
  String result = '引き分け';

  void selectHand(String selectedHand) {
    myHand = selectedHand;
    print(selectedHand);
    generatedComputerHand();
    judge();
    setState(() {});
  }

  void generatedComputerHand() {
    final randomNumber = Random().nextInt(3);
    computerHand = randomNumberToHand(randomNumber);
    print('computerHand : ${randomNumberToHand(randomNumber)}');
  }

  String randomNumberToHand(int randomNumber) {
    switch (randomNumber) {
      case 0:
        return ('✊️');
      case 1:
        return ('✌️');
      case 2:
        return ('🖐️');
      default:
        return ('✊️');
    }
  }

  void judge() {
    if(computerHand == myHand)
    {
      result = '引き分け';
    }
    else if(myHand == '✊️' && computerHand == '✌️'
    || myHand == '✌️' && computerHand == '🖐️'
    || myHand == '🖐️' && computerHand == '✊️')
    {
      result = '勝利';
    }
    else {
      result = '敗北';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Janken')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(result, style: TextStyle(fontSize: 32)),
            SizedBox(height: 40),
            Text(computerHand, style: TextStyle(fontSize: 32)),
            SizedBox(height: 40),
            Text(myHand, style: TextStyle(fontSize: 32)),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    selectHand('✊️');
                  },
                  child: Text('✊️'),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectHand('✌️');
                  },
                  child: Text('✌️'),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectHand('🖐️');
                  },
                  child: Text('🖐️'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
