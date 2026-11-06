import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 46, 69),
        title: const Text(
          'Profile Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Image
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withValues(alpha: 0.8),
                            blurRadius: 20,
                            spreadRadius: 10,
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/probg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Name
                    Text(
                      'Muhammad Fahad',
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    // Email
                    Text(
                      'fa8579364@gmail.com',
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Linkable Information
                    _buildLinkableBubble(
                      context,
                      icon: Icons.phone,
                      label: 'Phone',
                      value: '+923018920989',
                      color: Colors.green,
                      onTap: () => _launchPhone('+923018920989'),
                    ),
                    const SizedBox(height: 20),

                    _buildLinkableBubble(
                      context,
                      icon: Icons.email,
                      label: 'Email',
                      value: 'fa8579364@gmail.com',
                      color: Colors.blue,
                      onTap: () => _launchEmail('fa8579364@gmail.com'),
                    ),
                    const SizedBox(height: 20),

                    _buildLinkableBubble(
                      context,
                      icon: Icons.location_on,
                      label: 'Address',
                      value: 'Mian G Plaza Naguman, Peshawar, Pakistan',
                      color: Colors.red,
                      onTap: () => _launchMaps(
                          'Mian G Plaza Naguman, Peshawar, Pakistan'),
                    ),
                    const SizedBox(height: 20),

                    _buildActionButtons(isMobile),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ✅ Generic Linkable Bubble Container
  Widget _buildLinkableBubble(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap, // Trigger function when tapped
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue, // Make it look like a link
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Action Buttons (Edit Profile & Logout)
  Widget _buildActionButtons(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // Edit profile action
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              'Edit Profile',
              style: TextStyle(fontSize: isMobile ? 16 : 18),
            ),
          ),
        ),
        const SizedBox(width: 20),
        OutlinedButton(
          onPressed: () {
            // Logout action
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              'Logout',
              style: TextStyle(fontSize: isMobile ? 16 : 18),
            ),
          ),
        ),
      ],
    );
  }

  // ✅ Open Phone Dialer
  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  // ✅ Open Email Client
  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Inquiry about Services',
        'body': 'Hello, I would like to get more details about your services.',
      },
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  // ✅ Open Google Maps
  void _launchMaps(String address) async {
    final Uri mapsUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    if (await canLaunch(mapsUri.toString())) {
      await launch(mapsUri.toString());
    } else {
      throw 'Could not launch $mapsUri';
    }
  }
}
