import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constants.dart';
import 'package:grocery_app/firebase/firebase_service.dart';
import 'package:grocery_app/widget/custom_button.dart';

import '../../../gen/assets.gen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  bool _isLoading = false;
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    String pattern = r'\w+@\w+\.\w+';
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      try {
        final user = await FirebaseService().signInWithEmailAndPassword(
          _email,
          _password,
        );
        if (user != null) {
          Navigator.pushReplacementNamed(context, AppConstant.homeView);
        }
      } on FirebaseAuthException catch (e) {
        final snackBar =
            SnackBar(content: Text(e.message ?? 'An error occurred'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            alignment: Alignment.center,
            child: Image.asset(Assets.images.login_logo.path,
            height: 200,
            width: 350,),
          ),
          SizedBox(
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Admin Login',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0Xff21618C),)
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome To Insight Medics!',
                style: TextStyle(fontSize: 18, color: Color(0Xff21618C),
                fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          TextFormField(
              cursorHeight: 32,
              cursorWidth: 2,
              cursorColor: Colors.blueAccent,
              decoration: InputDecoration(labelText: 'Email address',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.email),
                  color: Colors.blueAccent.shade200,
                  onPressed: _toggleVisibility,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),),
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) {
                _email = value ?? '';
              },
              validator: _validateEmail),
          SizedBox(
            height: 22,
          ),
          TextFormField(
              cursorHeight: 32,
              cursorWidth: 2,
              cursorColor: Colors.blueAccent,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                suffixIcon: IconButton(
                  icon: _isHidden
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  color: Colors.blueAccent.shade200,
                  onPressed: _toggleVisibility,
                ),
              ),
              obscureText: _isHidden,
              onSaved: (value) {
                _password = value ?? '';
              },
              validator: _validatePassword),
          SizedBox(height: 10,),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     TextButton(onPressed: (){}, child: Text("Forgot Password",style: TextStyle(
          //       color: Colors.blueAccent,
          //       fontSize: 18,
          //       decoration: TextDecoration.underline,
          //       decorationColor: Colors.blueAccent,
          //     ),),)
          //   ],
          // ),
          SizedBox(
            height: 80,
          ),
          CustomButton(
            title: 'Login',
            backgroundColor: Colors.blueAccent.shade200,
            foregroundColor: Colors.white,
            callback: _signIn,
            isLoading: _isLoading,
          )
        ],
      ),
    );
  }
}
