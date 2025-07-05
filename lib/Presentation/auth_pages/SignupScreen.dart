import 'package:flutter/material.dart';
import 'package:quranapp/Presentation/auth_pages/SignIn.dart';
import 'package:quranapp/Presentation/home.dart';
import 'package:quranapp/authpage_validation/auth_form_validation.dart';
import 'package:quranapp/widgets/customButton.dart';
import 'package:quranapp/widgets/customtextfield.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  AuthFormValidation authFormValidation = AuthFormValidation();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  var obsuretxt = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(color: Colors.white),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Center(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo/quran_logo.jpeg',
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      customTextField(
                        "Enter your Full name",
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      customTextField(
                        "Enter Email Address",
                        controller: _emailController,
                        validator: AuthFormValidation.validateEmail,
                        prefixIcon: const Icon(Icons.email),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      customTextField(
                        "Enter your password",
                        controller: _passwordController,
                        isPassword: true,
                        validator:
                            (value) =>
                                AuthFormValidation.validatePassword(value),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      customTextField(
                        "Enter your password",
                        controller: _confirmPasswordController,
                        isPassword: true,
                        validator:
                            (value) =>
                                AuthFormValidation.validateConfirmPassword(
                                  value,
                                  _passwordController.text.trim(),
                                ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      CustomButton(
                        text: "R E G I S T E R",
                        width: MediaQuery.of(context).size.width * 0.5,
                        onPressed: () {
                          // Validate the form
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      const Text(
                        "Already have an\naccount ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
