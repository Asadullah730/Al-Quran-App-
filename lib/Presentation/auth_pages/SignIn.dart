import 'package:flutter/material.dart';
import 'package:quranapp/Presentation/auth_pages/SignupScreen.dart';
import 'package:quranapp/Presentation/home.dart';
import 'package:quranapp/authpage_validation/auth_form_validation.dart';
import 'package:quranapp/widgets/customButton.dart';
import 'package:quranapp/widgets/customtextfield.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var obscureText = true;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/quran_logo.jpeg',
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                customTextField(
                  "Enter Email Address",
                  controller: _emailController,
                  validator: AuthFormValidation.validateEmail,
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(height: 16),
                customTextField(
                  "Enter your password",
                  controller: _passwordController,
                  isPassword: true,
                  validator:
                      (value) => AuthFormValidation.validatePassword(value),
                  prefixIcon: const Icon(Icons.lock),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustomButton(
                  text: 'L O G I N',

                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                  },
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                const Text(
                  "Don't Have an account ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: const Text(
                    "REGISTER",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      color: Colors.green,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'OR',
                        style: TextStyle(fontSize: 14, color: Colors.green),
                      ),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
