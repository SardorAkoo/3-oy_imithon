import 'package:flutter/material.dart';
import 'package:imithon/services/auth_http_services.dart';
import 'package:imithon/views/screens/home_screen.dart';
import 'package:imithon/views/screens/reast_passwords.dart';
import 'package:imithon/views/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _authHttpServices = AuthHttpServices();
  bool isLoading = false;

  String? email;
  String? password;

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Iltimos elektron pochtangizni kiriting";
    }
    // Oddiy regex elektron pochta tekshiruvi uchun
    String pattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Iltimos yaroqli elektron pochta kiriting";
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Iltimos parolingizni kiriting";
    }
    return null;
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });
      try {
        await _authHttpServices.login(email!, password!);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return const HomeScreen();
            },
          ),
        );
      } on Exception catch (e) {
        String message = e.toString();
        if (e.toString().contains("EMAIL_EXISTS")) {
          message = "Email mavjud";
        } else if (e.toString().contains("INVALID_PASSWORD")) {
          message = "Noto'g'ri parol";
        } else if (e.toString().contains("EMAIL_NOT_FOUND")) {
          message = "Email topilmadi";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kirish",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.03),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "Elektron pochta",
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: emailValidator,
                onSaved: (newValue) {
                  email = newValue;
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "Parol",
                  prefixIcon: const Icon(Icons.lock),
                ),
                validator: passwordValidator,
                onSaved: (newValue) {
                  password = newValue;
                },
              ),
              SizedBox(height: screenHeight * 0.03),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.1,
                            vertical: screenHeight * 0.02),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        "KIRISH",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              SizedBox(height: screenHeight * 0.02),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return const RegisterScreen();
                      },
                    ),
                  );
                },
                child: const Text("Ro'yxatdan O'tish"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return const ResetPasswords();
                      },
                    ),
                  );
                },
                child: const Text("Parolni tiklash"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
