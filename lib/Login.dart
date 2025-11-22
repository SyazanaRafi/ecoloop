import 'package:flutter/material.dart';

// --- Custom Colors ---
const Color primaryGreen = Color(0xFF558B5C); // Main green for buttons/accents
const Color lightGrey = Color(0xFFE0E0E0); // Light grey for text fields
const Color secondaryGreenText = Color(
  0xFF4A7451,
); // Darker green for header/text
const Color backgroundWhite = Color(0xFFFFFFFF);
const Color linkBlue = Color(
  0xFF0000FF,
); // Blue for "Register here" and "Forgot Password?"

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30), // Space from top
              // 1. EcoLoop Logo
              Image.asset(
                'assets/ecoloop_logo.png', // Adjust if your logo is full text+graphic
                height: 200,
              ),

              // 2. Login Title
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: secondaryGreenText,
                  fontFamily: 'Roboto', // Assuming you want a similar font
                ),
              ),
              const SizedBox(height: 10),

              // 3. Don't have account? Register here.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Don't have account? ",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the Log In screen
                      Navigator.of(context).pushNamed('/signup');
                    },
                    child: const Text(
                      'Register here.',
                      style: TextStyle(
                        fontSize: 16,
                        color: linkBlue, // Blue color for the link
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 4. Username Input
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'USERNAME',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                hintText: 'Username',
              ), // Placeholder as per design
              const SizedBox(height: 25),

              // 5. Password Input
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PASSWORD',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(hintText: 'Password', obscureText: true),
              const SizedBox(height: 15),

              // 6. Forgot Password?
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Navigate to Forgot Password page
                    debugPrint('Forgot Password? tapped');
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 14,
                      color: linkBlue, // Blue color for the link
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 7. Login Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement login logic
                    // For now, let's navigate to the Home page after login
                    Navigator.of(context).pushReplacementNamed('/home');
                    debugPrint('Login button tapped');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: backgroundWhite,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50), // Space at the bottom
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for consistent text field styling
  Widget _buildTextField({required String hintText, bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 15.0,
          ),
          border: InputBorder.none, // Remove default TextField border
          focusedBorder: OutlineInputBorder(
            // Custom border when focused
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: primaryGreen, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            // Custom border when not focused
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.transparent, width: 0.0),
          ),
        ),
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }
}
