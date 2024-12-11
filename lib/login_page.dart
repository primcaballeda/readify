
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:readify/registration.dart';
import 'package:readify/root_page.dart';
import 'package:readify/user_auth/firebase_auth_implementation/firebase_auth_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Removes debug banner
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

TextEditingController usernameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

  final FirebaseAuthServices _firebaseAuthServices = FirebaseAuthServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFE8),
      ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _logo(),
        ),
      );
  }

  Widget _logo() {
    return Padding(
      
      padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _plogo(),
                const SizedBox(height: 10.0),
                _inputfield("Username or email", emailController),
                const SizedBox(height: 15.0),
                _inputfield("Password", passwordController, isPassword: true),
                const SizedBox(height: 8.0),
                _forgotpass(),
                const SizedBox(height: 8.0),
                _loginButton(),
                const SizedBox(height: 80.0),
                _extratext(),
                const SizedBox(height: 8.0),
                _registerButton(),
              ],
            ),
          ),
      ),
    );
  }

  Widget _plogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Image.asset(
        'assets/login_logo.png',
        width: 250,
        height: 250,
      ),
    );
  }
  Widget _inputfield(String labelText, TextEditingController controller, {isPassword = false}) {
  var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(
      color: Color(0xFFFFD4D4),
      width: 3.0,
    ),
  );

  return TextField(
    style: TextStyle(color: const Color(0xFF953154).withOpacity(0.49)),
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: const Color(0xFF953154).withOpacity(0.49)),
      enabledBorder: border,
      focusedBorder: border,
    ),
    obscureText: isPassword,
  );
}
Widget _loginButton() {
    return ElevatedButton(
       onPressed: () => _signIn(), 
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50), // Set the button size
        backgroundColor: const Color(0xFFFFD4D4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF953154).withOpacity(0.49),
          ),
        ),
      ),
    );
}

Widget _forgotpass() {
  return Container(
    alignment: Alignment.centerRight,
    child: Text(
      "Forgot Password?",
      style: TextStyle(
        color: const Color(0xFF953154).withOpacity(0.50),
        decoration: TextDecoration.underline, // Underline the text
        decorationColor: const Color(0xFF953154).withOpacity(0.50), // Match underline color with text color
      ),
    ),
  );
}
Widget _extratext2() {
  return Container(
    alignment: Alignment.centerLeft,
    child: const Text(
      "Password",
      style: TextStyle(
        color: Color(0xFF953154),
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
  );
}
Widget _extratext1() {
  return Container(
    alignment: Alignment.centerLeft,
    child: const Text(
      "Username",
      style: TextStyle(
        color: Color(0xFF953154),
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
  );
}
Widget _extratext() {
  return Text(
    "Doesn't have an account yet?",
    style: TextStyle(
      color: const Color(0xFF953154).withOpacity(0.58),
    ),
  );
}
Widget _registerButton() {
  return ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegistrationPage()),
      );
    },
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 50), // Set the button size
      backgroundColor: const Color(0xFFFFFFE8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Color(0xFFFFD4D4), // Stroke color
          width: 2.0,
        ),
      ),
    ),
    child: SizedBox(
      width: double.infinity,
      child: Text(
        "Register",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF953154).withOpacity(0.72),
        ),
      ),
    ),
  );
}

Future<void> _signIn() async {
  String username = usernameController.text;
  String email = emailController.text;
  String password = passwordController.text;


try {
  User? user = await _firebaseAuthServices.signInWithEmailAndPassword(email, password); 

  if (user != null) {
    print("User created successfully");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RootPage()),
    );
  } else {
    Fluttertoast.showToast(
      msg: "Incorrect Username or Password",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: const Color.fromARGB(157, 0, 0, 0),
      gravity: ToastGravity.SNACKBAR,
    );
  }
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.toString())),
  );
}
}
}

