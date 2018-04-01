import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

void main() => runApp(new MyHomePage());

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseUser user;
  static String _inputText = "";
  final TextEditingController _controller =
      new TextEditingController(text: _inputText);
  List<Widget> _list = new List<Widget>();

  @override
  initState() {
    super.initState();
    _getDocument(_list);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Flutter firebase playground'),
            ),
            drawer: _createDrawer(user),
            body: new ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: [
                  new Card(
                      color: Colors.white,
                      child: new Row(children: [
                        new Expanded(
                            child: new Padding(
                          padding: new EdgeInsets.all(5.0),
                          child: new TextField(
                              controller: _controller,
                              decoration: new InputDecoration(
                                hintText: 'Type something',
                              ),
                              onChanged: _changeText),
                        )),
                        new IconButton(
                          icon: new Icon(Icons.send),
                          tooltip: 'submit',
                          onPressed: _addCard,
                        )
                      ])),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: _list,
                  )
                ])));
  }

  void _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser siginUser = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    setState(() {
      user = siginUser;
    });
  }

  void _handleSignOut() async {
    _auth.signOut();
    setState(() {
      user = null;
    });
  }

  void _changeText(String text) {
    _inputText = text;
  }

  void _getDocument(List<Widget> list) async {
    QuerySnapshot snapShot =
        await Firestore.instance.collection('memo').getDocuments();

    setState(() {
      snapShot.documents.forEach((DocumentSnapshot ds) {
        SizedBox box = new SizedBox(
          width: 300.0,
          height: 50.0,
          child: new Card(child: new Text(ds.data['text'])),
        );
        list.add(box);
      });
    });
  }

  void _addCard() {
    Firestore.instance
        .collection('memo')
        .document()
        .setData({'text': _inputText});
    setState(() {
      SizedBox box = new SizedBox(
        width: 300.0,
        height: 50.0,
        child: new Card(child: new Text(_inputText)),
      );
      _list.add(box);
    });
  }

  Widget _createDrawer(FirebaseUser user) {
    Text displayName = new Text('Guest');
    Text email = new Text('Guest');
    CircleAvatar avator = new CircleAvatar(
      backgroundColor: Colors.blue,
      child: new Text('G'),
    );

    if (user != null) {
      displayName = new Text(user.displayName);
      email = new Text(user.email);
      avator =
          new CircleAvatar(backgroundImage: new NetworkImage(user.photoUrl));
    }
    return new Drawer(
        child: new ListView(
      children: <Widget>[
        new UserAccountsDrawerHeader(
            accountName: displayName,
            accountEmail: email,
            currentAccountPicture: avator),
        new ListTile(
          title: new Text('Sigin In Google'),
          leading: new Icon(FontAwesomeIcons.google),
          onTap: _handleSignIn,
        ),
        new ListTile(
          title: new Text('Sigin Out Google'),
          onTap: _handleSignOut,
        )
      ],
    ));
  }
}
