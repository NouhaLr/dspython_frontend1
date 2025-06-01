import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/api_service.dart'; // Assure-toi d'importer ApiService

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String message = "";

  void handleResetPassword(BuildContext context) async {
    setState(() {
      isLoading = true;
      message = "";
    });

    final success = await ApiService.resetPassword(
      emailController.text,
      passwordController.text,
    );

    setState(() {
      isLoading = false;
      message = success
          ? "Mot de passe réinitialisé avec succès."
          : "Erreur lors de la réinitialisation.";
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mot de passe réinitialisé avec succès! 🔒'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF8C00), Color(0xFFFF2E63)], // Orange vers rose
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    "Réinitialiser le mot de passe 🔑",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(duration: 700.ms).slideX(begin: -1),
                  const SizedBox(height: 30),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Entrez votre email",
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                  ).animate().fadeIn(duration: 700.ms).slideY(begin: 1),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Nouveau mot de passe",
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ).animate().fadeIn(duration: 700.ms).slideY(begin: 1),
                  const SizedBox(height: 30),
                  isLoading
                      ? Center(child: CircularProgressIndicator(color: Colors.white))
                      : ElevatedButton(
                    onPressed: () => handleResetPassword(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      "Réinitialiser",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 1),
                  if (message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          message,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ).animate().fadeIn(duration: 700.ms),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
