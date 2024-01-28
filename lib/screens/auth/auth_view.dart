// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shubham_weather/services/auth_service.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Function(String) validator;
  final Function(String) onSaved;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.validator,
    required this.onSaved,
    this.obscureText = false,
    required this.keyboardType,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: hintText,
          hintText: hintText,
          fillColor: Color(0xFF1B1B1B),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) => validator(value!),
        onSaved: (value) => onSaved(value!),
        obscureText: obscureText,
      ),
    );
  }
}

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullnameController = TextEditingController();
  String email = '';
  String password = '';
  String fullname = '';
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('Shubham Weather'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/appLogo.png'),
                  fit: BoxFit.cover,
                ),
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!login)
                      CustomTextField(
                        controller: _fullnameController,
                        hintText: 'Enter Full Name',
                        validator: (value) =>
                            value.isEmpty ? 'Please Enter Full Name' : null,
                        onSaved: (value) => setState(() => fullname = value),
                        keyboardType: TextInputType.name,
                      ),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Enter Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value.isEmpty || !value.contains('@')
                              ? 'Please Enter valid Email'
                              : null,
                      onSaved: (value) => setState(() => email = value),
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: 'Enter Password',
                      validator: (value) => value.length < 6
                          ? 'Please Enter Password of min length 6'
                          : null,
                      onSaved: (value) => setState(() => password = value),
                      obscureText: true,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (login) {
                              await AuthServices.signinUser(
                                  email, password, context);
                            } else {
                              await AuthServices.signupUser(
                                  email, password, fullname, context);
                            }
                          }
                        },
                        child: Text(
                          login ? 'Login' : 'Signup',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          login = !login;
                          _emailController.clear();
                          _passwordController.clear();
                          _fullnameController.clear();
                        });
                      },
                      child: Text(
                        login
                            ? 'Don\'t have an account?'
                            : 'Already have an account?',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
