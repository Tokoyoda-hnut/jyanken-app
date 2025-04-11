import 'package:flutter/material.dart';
import 'package:jinsei_app/life_event.dart';
import 'package:jinsei_app/objectbox.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LifeCounterPage(), 
    );
  }
}  

class LifeCounterPage extends StatefulWidget {
  const LifeCounterPage({super.key});

  @override
  State <LifeCounterPage> createState() =>  _LifeCounterPageState();
}

class  _LifeCounterPageState extends State <LifeCounterPage> {
 
 Store? store;
 Box<LifeEvent>? lifeEventBox; // null許容


 Future<void> initialize() async {
  store = await openStore();
  lifeEventBox = store?.box<LifeEvent>(); //storeがヌルの場合でも処理したい
  setState(() {});
 }

 @override
 void initState() {
  super.initState();
  store = openStore();
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Life Counter'),
      ),
    );
  }
}
