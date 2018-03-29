import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Flutter firebase playground'),
            ),
            body: new ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: [
                  new SizedBox(
                      height: 400.0,
                      child: new Card(
                          color: Colors.white,
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: new Text(
                                    'firebase auth',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ]))),
                  new SizedBox(
                      height: 400.0,
                      child: new Card(
                          color: Colors.white,
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: new Text(
                                    'fire store',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ])))
                ])));
  }
}
