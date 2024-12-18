import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      home: RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuthServices _firebaseAuthServices = FirebaseAuthServices();
  final _formKey = GlobalKey<FormState>();
  
  TextEditingController fullnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    fullnameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFE8),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _form(),
      ),
    );
  }

  Widget _form() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _plogo(),
                
                _inputfield("Fullname", fullnameController),
                const SizedBox(height: 15.0),
                _inputfield("Username", usernameController),
                const SizedBox(height: 15.0),
                _inputfield("Email", emailController, isEmail: true),
                const SizedBox(height: 15.0),
                _inputfield("Password", passwordController, isPassword: true),
                const SizedBox(height: 15.0),
                _inputfield("Confirm Password", confirmpasswordController, isPassword: true, isConfirmPassword: true),
                const SizedBox(height: 20),
                _registerButton(),
                const SizedBox(height: 100.0),
              ],
            ),
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
        width: 300,
        height: 300,
      ),
    );
  }

  Widget _inputfield(String hintText, TextEditingController controller, {bool isPassword = false, bool isEmail = false, bool isConfirmPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: Color(0xFFFFD4D4),
        width: 3.0,
      ),
    );

    return TextFormField(
      style: TextStyle(color: const Color(0xFF953154).withOpacity(0.49)),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: const Color(0xFF953154).withOpacity(0.49)),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword || isConfirmPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hintText is a required field';
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter a valid email address';
        }
        if (isConfirmPassword && value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _registerButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _signUp();
        }
      },
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
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF953154).withOpacity(0.49),
          ),
        ),
      ),
    );
  }

 Future<void> _signUp() async {
  String fullname = fullnameController.text;
  String username = usernameController.text;
  String email = emailController.text;
  String password = passwordController.text;

  try {
    // Use the modified sign-up method that includes full name and username
    User? user = await _firebaseAuthServices.signUpWithEmailAndPassword(
      email, 
      password, 
      fullname, 
      username,
    );

    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RootPage()),
      );
    } else {
      // Display error if user creation fails
      Fluttertoast.showToast(
        msg: "Account creation failed. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: const Color.fromARGB(157, 0, 0, 0),
        gravity: ToastGravity.SNACKBAR,
      );
    }
  } catch (e) {
    // Show error message if something goes wrong during the sign-up process
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}

}
