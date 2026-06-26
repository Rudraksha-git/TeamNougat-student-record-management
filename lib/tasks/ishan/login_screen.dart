import 'package:flutter/material.dart';
import 'auth_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              // Title
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(text: 'Student '),
                    TextSpan(
                      text: 'Record',
                      style: TextStyle(color: Color(0xFF1A237E)),
                    ),
                    TextSpan(text: '\nManagement App'),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              // Sign In Button
              _buildButton(
                context,
                label: 'Sign In',
                color: const Color(0xFF5D4FBE),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AuthScreen(isSignUp: false),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Sign Up Button
              _buildButton(
                context,
                label: 'Sign Up',
                color: const Color(0xFF5D4FBE),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AuthScreen(isSignUp: true),
                    ),
                  );
                },
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 2,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}