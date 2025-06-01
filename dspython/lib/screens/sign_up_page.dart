import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String error = "";

  void handleSignUp() async {
    setState(() {
      isLoading = true;
      error = "";
    });

    bool success = await ApiService.signup(
      usernameController.text,
      emailController.text,
      passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      setState(() {
        error = "Échec de l'inscription. Vérifiez les informations.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)], // 💜💙 Dégradé violet/bleu
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bienvenue !",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -1), // Animation ✨
              const SizedBox(height: 10),
              Text(
                "Créez votre compte pour continuer",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -1),
              const SizedBox(height: 40),
              _buildInputField(
                controller: usernameController,
                label: "Nom d'utilisateur",
                icon: Icons.person,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: emailController,
                label: "Email",
                icon: Icons.email,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: passwordController,
                label: "Mot de passe",
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 30),
              isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.white))
                  : ElevatedButton(
                onPressed: handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text("S'inscrire"),
              ).animate().fadeIn(duration: 500.ms).scale(),
              if (error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                ),
              const SizedBox(height: 30),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: Text(
                    "Déjà inscrit ? Se connecter",
                    style: TextStyle(color: Colors.white70),
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
