import 'package:flutter/material.dart';
import 'Login.dart';

// --- Custom Colors (define these outside the class or in a separate file) ---
const Color primaryGreen = Color(0xFF558B5C);
const Color secondaryGreen = Color(0xFF4A7451);
const Color hintGrey = Color(0xFFEFEFEF);
const Color linkBlue = Color(0xFF485A82);

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Set AppBar to be transparent (optional, but cleaner)
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 1. Title Text
            const Text(
              'Create New\nAccount',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Georgia', // Approximation for a classic serif font
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: secondaryGreen,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 15),

            // 2. Already Registered Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already Registered? ',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to the Log In screen
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: const Text(
                    'Log in here.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 255),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            // 3. Form Fields
            _buildInputField(label: 'USERNAME', hintText: 'Username'),
            _buildInputField(
              label: 'EMAIL',
              hintText: 'youremail@gmail.com',
              keyboardType: TextInputType.emailAddress,
            ),
            _buildInputField(
              label: 'PASSWORD',
              hintText: 'Password',
              isPassword: true,
            ),
            _buildInputField(
              label: 'CONFIRM PASSWORD',
              hintText: 'Password',
              isPassword: true,
              marginBottom: 40.0,
            ),

            // 4. Sign Up Button
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement sign up logic (validation, API call, etc.)
                  // For now navigate to the Home page after successful sign up
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for creating the stylized form fields
  Widget _buildInputField({
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    double marginBottom = 25.0,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black, // Dark text for the label
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: keyboardType,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black45),
              filled: true,
              fillColor: hintGrey, // Light grey background
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18.0,
                horizontal: 15.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none, // No border visible
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: primaryGreen, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
