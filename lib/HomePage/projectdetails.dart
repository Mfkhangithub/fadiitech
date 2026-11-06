import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:websidefadii/HomePage/ourwork.dart';

class ProjectDetailsPage extends StatefulWidget {
  final Project project;

  const ProjectDetailsPage({super.key, required this.project});

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  String? _description;

  @override
  void initState() {
    super.initState();
    _loadDynamicData();
  }

  Future<void> _loadDynamicData() async {
    final imageProvider = AssetImage(widget.project.imagePath);
    final description = _getDescriptionForProject(widget.project.name);

    setState(() {
      _description = description;
    });
  }

  Future<Color> getDominantColor(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor?.color ?? Colors.black;
  }

  String _getDescriptionForProject(String projectName) {
    // Add your custom descriptions for each project
    switch (projectName) {
      case 'Sports App':
        return "A feature-rich sports app designed to provide real-time updates, live scores, and player statistics.";
      case 'Chat App':
        return "A real-time chat application with end-to-end encryption and multimedia support.";
      case 'E-commerce App':
        return "An e-commerce platform with seamless payment integration and a user-friendly interface.";
      case 'Todo App':
        return "A simple yet powerful to-do app to help you manage your tasks efficiently.";
      case 'Music App':
        return "A music streaming app with a vast library of songs and personalized playlists.";
      case 'Food Delivery App':
        return "A food delivery app that connects users with their favorite restaurants.";
      case 'Portfolio':
        return "A personal portfolio website showcasing my projects and skills.";
      case 'Gym App':
        return "A fitness app designed to help users track their workouts and progress.";
      default:
        return "This is a detailed description of the project.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(widget.project.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Project Name
            Text(
              widget.project.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // Project Description
            const Text(
              "Project Description:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _description ?? "Loading description...",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            // Features Section
            const Text(
              "Features:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeature("Responsive Design"),
                _buildFeature("User Authentication"),
                _buildFeature("Real-time Chat"),
                _buildFeature("Payment Integration"),
                _buildFeature("Custom Animations"),
              ],
            ),
            const SizedBox(height: 20),

            // Technologies Used
            const Text(
              "Technologies Used:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildTechChip("Flutter"),
                _buildTechChip("Firebase"),
                _buildTechChip("Dart"),
                _buildTechChip("Figma"),
                _buildTechChip("VS Code"),
                _buildTechChip("Android Studio"),
                _buildTechChip("REST API"),
              ],
            ),
            const SizedBox(height: 20),

            // Call to Action Button
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Add functionality like visiting a live demo or GitHub repo
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: const Color.fromARGB(255, 0, 43, 67),
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 40,
            //         vertical: 16,
            //       ),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30),
            //       ),
            //     ),
            //     child: const Text(
            //       "Visit Live Demo",
            //       style: TextStyle(
            //         fontSize: 18,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Helper method to build feature list items
  Widget _buildFeature(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color.fromARGB(255, 0, 43, 67),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            feature,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build technology chips
  Widget _buildTechChip(String tech) {
    return Chip(
      label: Text(
        tech,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 43, 67),
    );
  }
}
