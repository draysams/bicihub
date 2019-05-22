import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loggedIn = false;

  bool _authorized = false;
  
  String emailValidationText = "";
  String passwordValidationText = "";

  bool validated = false;

  bool validEmail = false;
  bool validPassword = false;

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  void _navChatScreen() {
    Navigator.of(context).pushNamed('/menu');
  }

  void _navSignUp() {
    Navigator.of(context).pushNamed('/signup');
  }

  _getCurrentUser () async {
    print("-----------------------------------------");
    print('Hello ' + _emailController.text.toString());
    setState(() {
      loggedIn = true;
    });
    if (loggedIn) {
      _navChatScreen();
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    final logo = new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: new Image.asset('assets/transfeed.png'),
      ),
    );

    final email = new TextField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _emailController,
      onChanged: validateEmail,
      decoration: new InputDecoration(
        hintText: 'Email',
        contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(32.0)),
      ),
    );

    final password = new TextField(
      autofocus: false,
      obscureText: true,
      controller: _passwordController,
      onChanged: validatePassword,
      decoration: new InputDecoration(
        hintText: 'Password',
        contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = new Padding(
      padding: new EdgeInsets.symmetric(vertical: 16.0),
      child: new Material(
        borderRadius: new BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: new CupertinoButton(
          onPressed: _emailAuthenticate,
          color: CupertinoColors.activeBlue,
          child: new Text('Log In', style: new TextStyle(color: Colors.white)),
        ),
      ),
    );

    final googleButton = new Padding(
      padding: new EdgeInsets.symmetric(vertical: 8.0),
      child: new Material(
        borderRadius: new BorderRadius.circular(30.0),
        shadowColor: CupertinoColors.lightBackgroundGray,
        elevation: 5.0,
        child: new CupertinoButton(
          onPressed: null,
          color: CupertinoColors.lightBackgroundGray,
          child: new Text('Google Login', style: new TextStyle(color: Colors.black87)),
        ),
      ),
    );

    final _emailValidationLabel = new Center(
        child: new Text(
      emailValidationText,
      style: new TextStyle(color: Colors.red),
    ));

    final _passwordValidationLabel = new Center(
        child: new Text(
      passwordValidationText,
      style: new TextStyle(color: Colors.red),
    ));
    final signUpLabel = new FlatButton(
      child: new Text(
        'Don\'t have an account? Sign Up',
        style: new TextStyle(color: Colors.black54),
      ),
      onPressed: _navSignUp,
    );

    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Center(
        child: new ListView(
          shrinkWrap: true,
          padding: new EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            new SizedBox(height: 48.0),
            email,
            new SizedBox(height: 15.0),
            password,
            new SizedBox(height: 5.0),
            _emailValidationLabel,
            new SizedBox(height: 5.0),
            _passwordValidationLabel,
            new SizedBox(height: 30.0),
            loginButton,
            googleButton,
            signUpLabel
          ],
        ),
      ),
    );
  }

  void _handleEmail() async {
    try {
      _navChatScreen(); 
    } catch(e) {
      print(e);
    }
  }

  Future<Null> _emailAuthenticate() async {
    bool authenticated = false;
    if (!mounted) return;

    setState(() {
      _authorized = authenticated ? true : false;
      if(_authorized) {
        _handleEmail();
      }
    });
  }

    bool validateInputs() {
    if (validPassword && validEmail) {
      return true;
    } else {
      return false;
    }
  }

  bool isEmail(emailString) => RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailString);

  void validateEmail(String value) {
    if (!isEmail(value)) {
      setState(() {
        emailValidationText = "* This is not a valid email.";
      });
    } else {
      setState(() {
        emailValidationText = "";
        validEmail = true;
      });
    }
  }

  void validatePassword(String value) {
    String password = _passwordController.text;
    if (password.length < 7) {
      setState(() {
        passwordValidationText = "* 8 or more characters required";
      });
    } else {
      setState(() {
        passwordValidationText = "";
        validPassword = true;
      });
    }
  }
}