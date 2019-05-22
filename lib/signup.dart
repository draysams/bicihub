import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignUpPage extends StatefulWidget {
  static String tag = 'signup-page';

  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String emailValidationText = "";
  String passwordValidationText = "";
  String repeatValidationText = "";
  bool validated = false;

  bool validEmail = false;
  bool validPassword = false;
  bool validRepeat = false;

  void _navChatScreen() {
    Navigator.of(context).pushNamed('/menu');
  }

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _repeatController = new TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatController.dispose();
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
        border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(32.0)),
      ),
    );

    final password = new TextField(
      autofocus: false,
      controller: _passwordController,
      obscureText: true,
      onChanged: validatePassword,
      decoration: new InputDecoration(
        hintText: 'Password',
        contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(32.0)),
      ),
    );

    final repeatPassword = new TextField(
      autofocus: false,
      controller: _repeatController,
      obscureText: true,
      onChanged: validateRepeat,
      decoration: new InputDecoration(
        hintText: 'Password',
        contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(32.0),
          borderSide: new BorderSide(width: 16.0, color: Colors.red),
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

    final _repeatValidationLabel = new Center(
        child: new Text(repeatValidationText,
            style: new TextStyle(color: Colors.red)));

    final signUpButton = new Padding(
      padding: new EdgeInsets.symmetric(vertical: 16.0),
      child: new Material(
        borderRadius: new BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: new MaterialButton(
          minWidth: 130.0,
          height: 42.0,
          onPressed: _handleSignUp,
          color: CupertinoColors.activeBlue,
          child: new Text('Sign Up', style: new TextStyle(color: Colors.white)),
        ),
      ),
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
            new SizedBox(height: 10.0),
            password,
            new SizedBox(height: 10.0),
            repeatPassword,
            new SizedBox(height: 10.0),
            _emailValidationLabel,
            new SizedBox(height: 5.0),
            _passwordValidationLabel,
            new SizedBox(height: 5.0),
            _repeatValidationLabel,
            signUpButton,
          ],
        ),
      ),
    );
  }

  void _handleSignUp() async {
    if (validateInputs()) {
      try {
        _navChatScreen();
      } catch (e) {
        print(e);
      }
    } else {
      print("Sorry you can't go.");
    }
  }

  bool validateInputs() {
    if (validPassword && validRepeat && validEmail) {
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

  void validateRepeat(String value) {
    String password = _passwordController.text;
    if (password != value) {
      setState(() {
        repeatValidationText = "* The passwords don't match.";
      });
    } else {
      setState(() {
        repeatValidationText = "";
        validRepeat = true;
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
