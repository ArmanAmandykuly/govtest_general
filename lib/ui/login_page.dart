import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:govtest_general/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  bool isFormValid = false;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: true);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, size: 80, color: Colors.blue),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    errorText: authViewModel.emailErrorMessage,
                    border: OutlineInputBorder(),
                  ),
                  onChanged:
                      (val) => setState(() {
                        isFormValid = _formKey.currentState!.validate();
                        email = val;
                        log("Email: $email Password: $password");
                      }),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    } else if (!EmailValidator.validate(value)) {
                      return "Invalid email format";
                    }
                    return null; // No error
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    errorText: authViewModel.passwordErrorMessage,
                  ),
                  obscureText: true,
                  onChanged:
                      (val) => {
                        setState(() {
                          isFormValid = _formKey.currentState!.validate();
                          password = val;
                        }),
                      },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    } else if (value.length < 8) {
                      return "Password must be at least 8 characters";
                    } else if (!RegExp(
                      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$',
                    ).hasMatch(value)) {
                      return "Password must contain a letter, number, and special character";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                OutlinedButton(
                  onPressed:
                      isFormValid
                          ? () => {
                            authViewModel.loginUserWithEmailAndPassword(
                              email!,
                              password!,
                              () {
                                Navigator.pushNamed(context, "/");
                              },
                            ),
                          }
                          : null,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Login", style: TextStyle(fontSize: 18)),
                ),
                // Padding(
                //   padding: EdgeInsets.only(bottom: 10),
                //   child: Text(
                //     authViewModel.auth.currentUser?.uid ?? "Not logged in",
                //     style: TextStyle(color: Colors.blue, fontSize: 16),
                //   ),
                // ),
                if (authViewModel.errorMessage != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      authViewModel.errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
