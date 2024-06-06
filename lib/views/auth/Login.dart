import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_praktikum/views/HomeNews.dart';
import 'package:project_praktikum/views/MediaCategories.dart';

import 'Register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String email = '';
  String password = '';

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _tryLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (userCredential.user != null) {
          bool isNewUser = userCredential!.user!.metadata!.creationTime == userCredential.user!.metadata!.lastSignInTime;
          if (isNewUser) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MediaCategories()),
                  (Route<dynamic> route) => false,
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeNews()),
                  (Route<dynamic> route) => false,
            );
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!'), backgroundColor: Colors.green,),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.'), backgroundColor: Colors.red,),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.newspaper,
                size: 30,
                color: Colors.red[500],
              ),
            ),
            SizedBox(width: 10),
            Text(
              'SIBAS NEWS!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.business,
                  size: 100,
                  color: Colors.red,
                ),
                SizedBox(height: 20),
                Text(
                  'SIBAS NEWS!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  width: 350,
                  child: _emailForm(),
                ),
                SizedBox(height: 10),
                Container(
                  width: 350,
                  child: _passwordForm(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _tryLogin,
                  child: Text('Login', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue, // Warna default
                      ),
                      children: [
                        TextSpan(
                          text: 'Don\'t have an account? ',
                        ),
                        TextSpan(
                          text: 'Register here',
                          style: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailForm() {
    return TextFormField(
      onSaved: (value) => email = value!,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        labelText: 'Email',
        prefixIcon: Icon(Icons.mail),
        fillColor: Colors.white,
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  Widget _passwordForm() {
    return TextFormField(
      onSaved: (value) => password = value!,
      obscureText: _obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: _togglePasswordVisibility,
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }
}
