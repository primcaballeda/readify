import 'package:flutter/material.dart';
import 'package:readify/user_auth/firebase_auth_implementation/firebase_auth_services.dart'; // Import your FirebaseAuthServices file

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuthServices _authServices = FirebaseAuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFE8),
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: const Color(0xFFFFFFE8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Enter your email address to reset your password',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xFFFFBEBE)),
                    minimumSize: MaterialStateProperty.all(const Size(120.0, 50.0)),
                  ),
                  onPressed: () async {
                    final email = emailController.text.trim();

                    if (email.isNotEmpty) {
                      try {
                        // Call resetPassword from FirebaseAuthServices
                        await _authServices.resetPassword(email);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password reset link sent! Check your inbox.')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter your email')),
                      );
                    }
                  },
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(color: Color(0xFF953154)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
