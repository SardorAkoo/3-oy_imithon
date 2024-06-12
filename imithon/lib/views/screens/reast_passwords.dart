import 'package:flutter/material.dart';
import 'package:imithon/services/auth_http_services.dart';
import 'package:imithon/views/screens/login_screen.dart';

class ResetPasswords extends StatefulWidget {
  const ResetPasswords({Key? key}) : super(key: key);

  @override
  State<ResetPasswords> createState() => _ResetPasswordsState();
}

class _ResetPasswordsState extends State<ResetPasswords> {
  final formKey = GlobalKey<FormState>();
  final _authHttpServices = AuthHttpServices();

  String? email;
  bool isLoading = false;

  void resetPassword() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });
      try {
        await _authHttpServices.resetPassword(email!);

        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Muvaffaqiyat"),
              content: const Text(
                  "Parolni tiklash uchun email manzilga yuborilgan ko'rsatmalarni bajaring."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) {
                          return const LoginScreen();
                        },
                      ),
                    );
                  },
                  child: const Text("Kirish"),
                ),
              ],
            );
          },
        );
      } catch (e) {
        String message = e.toString();
        if (e.toString().contains("EMAIL_NOT_FOUND")) {
          message = "Email topilmadi";
        }
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Xatolik"),
              content: Text(message),
            );
          },
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
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (ctx) {
                  return const LoginScreen();
                },
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            weight: screenWidth * 0.05,
          ),
        ),
        title: const Text(
          "Parolni tiklash",
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
            children: [
              const FlutterLogo(
                size: 90,
              ),
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Iltimos elektron pochtangizni kiriting";
                  }
                  String pattern = r'^[^@]+@[^@]+\.[^@]+';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return "Iltimos yaroqli elektron pochta kiriting";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  email = newValue;
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: resetPassword,
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
                        "Parolni tiklash",
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
                        return const LoginScreen();
                      },
                    ),
                  );
                },
                child: const Text("Kirish"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
