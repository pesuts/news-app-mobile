import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String email = '';
  String password = '';
  String name = '';

  void _tryRegister() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await userCredential.user?.updateDisplayName(name);
        // await userCredential.user?.updateProfile(displayName: displayName);

        // Simpan data tambahan pengguna ke Firestore
        // await saveUserData(userCredential.user!);
        // User registered successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!'), backgroundColor: Colors.green,),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.'), backgroundColor: Colors.red,),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "SIBAS News",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue
                    ),
                  ),
                  Icon(
                    Icons.business,
                    size: 100,
                    color: Colors.red,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Create Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 350,
                    child: _nameForm(),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 350,
                    child: _emailForm(),
                  ),
                  SizedBox(height: 10),
                  // Password
                  Container(
                    width: 350,
                    child: _passwordForm(),
                  ),
                  SizedBox(height: 25),


                  // Register Button
                  Container(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _tryRegister,
                      child: Text('Register', style: TextStyle(
                        color: Colors.white,
                      ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account? ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue, // Warna default
                        ),
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              )
                            );
                          },
                          child: Text('Login',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameForm() {
    Widget icon = Icon(Icons.person);
    return _textForm("Name", icon, (value) => name = value);
  }

  Widget _emailForm() {
    Widget icon = Icon(Icons.mail);
    return _textForm("Email", icon, (value) => email = value);
  }

  Widget _passwordForm() {
    return _textForm("Password", null, (value) => password = value);
  }

  Widget _textForm(String label, Widget? icon, Function(String) onSaved) {
    bool isPasswordField = label == "Password";

    return TextFormField(
      obscureText: isPasswordField ? _obscureText : false,
      onSaved: (value) => onSaved(value!),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        labelText: label,
        prefixIcon: icon ?? Icon(Icons.lock),
        suffixIcon: isPasswordField
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
        fillColor: Colors.blue[50],
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your ${label.toLowerCase()}';
        }
        return null;
      },
    );
  }
}
