import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

void main() => runApp(new MyHomePage());

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseUser user;

  @override
  initState() {
    super.initState();
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

  void _handleSignOut() {
    _auth.signOut();
    setState(() {
      user = null;
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
