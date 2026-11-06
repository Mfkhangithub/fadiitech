import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:websidefadii/HomePage/LoginPage/welcomepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false; // Password visibility toggle state

  // Show loading dialog
  Future<void> _showProgressDialog() async {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
          ),
          elevation: 0, // Remove default shadow
          backgroundColor: Colors.transparent, // Transparent background
          child: const Column(
            mainAxisSize: MainAxisSize.min, // Wrap content height
            children: [
              // Replace default loader with SpinKitDualRing
              SpinKitCircle(
                color: Colors.white, // Custom color
                size: 50.0,
                // lineWidth: 4.0,
              ),
              SizedBox(height: 20), // Spacing
              Text(
                "Loading...",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Simulate a long-running action (like an API call)
  Future<void> _handleButtonPress() async {
    await _showProgressDialog(); // Show progress dialog

    // Simulate a delay (e.g., API call or login action)
    await Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Dismiss the dialog after the delay
    });

    // You can now proceed with the actual logic, like navigating to a new screen, etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/bgsoft.jpg', // Your background image
              fit: BoxFit.cover, // Make sure the image covers the entire screen
            ),
          ),
          // Centered Form
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 400, // Adjust width of the form container
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                      alpha:
                          0.8), // Slight transparency to make the form visible
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Company Logo
                    CircleAvatar(
                      radius: 40, // Adjust size as needed
                      backgroundColor:
                          Colors.transparent, // Set background color if needed
                      child: ClipOval(
                        child: Image.asset(
                          'assets/probg.png', // Your logo asset path
                          fit: BoxFit.cover,
                          width: 80, // Adjust according to your design
                          height: 80,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Welcome Message
                    const Text(
                      "Welcome to FADIITECH",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Subheading
                    const Text(
                      "Please log in using the form below",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Email TextField
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                            color: Colors.grey.shade700, fontSize: 15),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.grey.shade700,
                          size: 20,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.blue.shade300, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password TextField
                    TextField(
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                            color: Colors.grey.shade700, fontSize: 15),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey.shade700,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey.shade700,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.blue.shade300, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Forgot Password and Remember Me
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (value) {
                                // Handle Remember Me action
                              },
                            ),
                            const Text(
                              "Remember me",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle forgot password
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WelcomePage(username: 'Muhammad Fahad'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 0, 43, 67),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Divider with "Or"
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "OR",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Google Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _handleButtonPress,
                        icon: Image.asset(
                          'assets/googlelogo.png', // Replace with your Google logo asset path
                          height: 24,
                        ),
                        label: const Text("Continue with Google"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Apple Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _handleButtonPress,
                        icon: const Icon(Icons.apple,
                            size: 24, color: Colors.black),
                        label: const Text("Continue with Apple"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Sign Up Prompt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: _handleButtonPress,
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
