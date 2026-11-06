import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 46, 69),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSectionTitle('About Us'),
              _buildAboutUsContent(),
              const SizedBox(height: 40),
              _buildSectionTitle('Contact Us'),
              _buildContactUsSection(),
              const SizedBox(height: 40),
              _buildSectionTitle('Our Team'),
              _buildTeamSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildAboutUsContent() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "Welcome to TechMinds, where innovation meets creativity. Our mission is to provide top-notch software development services "
        "to empower businesses worldwide. With a passion for technology and a dedication to excellence, we specialize in delivering "
        "customized solutions tailored to your unique needs. Thank you for choosing us as your trusted technology partner.",
        style: TextStyle(fontSize: 16, height: 1.5),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContactUsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildContactBubble(
          icon: Icons.phone,
          label: 'Phone',
          value: '+92301-8920-989',
          color: Colors.green,
        ),
        const SizedBox(height: 20),
        _buildContactBubble(
          icon: Icons.email,
          label: 'Email',
          value: 'fa8579364@gmail.com',
          color: Colors.blue,
        ),
        const SizedBox(height: 20),
        _buildContactBubble(
          icon: Icons.location_on,
          label: 'Address',
          value: 'Mian G Plaza Naguman, Peshawar, Pakistan',
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildContactBubble({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50), // Bubble shape
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    List<Map<String, String>> teamMembers = [
      {
        'name': 'Muhammad Fahad',
        'role': 'Lead Developer',
        'image': 'assets/fahad.png',
      },
      {
        'name': 'John Doe',
        'role': 'UI/UX Designer',
        'image': 'assets/john.png',
      },
      {
        'name': 'Jane Smith',
        'role': 'Project Manager',
        'image': 'assets/jane.png',
      },
    ];

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: teamMembers.map((member) {
        return _buildTeamCard(
          name: member['name']!,
          role: member['role']!,
          image: member['image']!,
        );
      }).toList(),
    );
  }

  Widget _buildTeamCard({
    required String name,
    required String role,
    required String image,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            role,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
