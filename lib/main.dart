import 'package:flutter/material.dart';
import 'package:tickerissue/percent_digits.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _counter = 12.3;

  void _incrementCounter() {
    setState(() {
      _counter+=9.8;
    });
  }
  void _decrementCounter() {
    setState(() {
      _counter-=9.8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PercentDigits(gain: _counter.toString()),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(children: [
          FloatingActionButton(onPressed: _incrementCounter, child: const Icon(Icons.add),),
          FloatingActionButton(onPressed: _decrementCounter, child: const Icon(Icons.remove),),
        ],
      ),
    );
  }
}
