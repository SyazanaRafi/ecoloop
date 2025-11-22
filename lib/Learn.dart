import 'package:flutter/material.dart';
import 'Profile.dart';

// --- Custom Colors ---
const Color primaryGreen = Color(0xFF558B5C); // Main accent green
const Color cardGreen = Color(
  0xFFC7DAB8,
); // Muted green for the card background
const Color secondaryGreenText = Color(0xFF4A7451); // Darker green for text
const Color backgroundWhite = Color(0xFFFFFFFF);

// Data model for our learning cards
class LearningTopic {
  final String title;
  final String content;
  final String imagePath;

  const LearningTopic({
    required this.title,
    required this.content,
    required this.imagePath,
  });
}

class LearnPage extends StatelessWidget {
  final int? initialTopicIndex;

  const LearnPage({super.key, this.initialTopicIndex});

  // Sample data to populate the cards
  final List<LearningTopic> _alltopics = const [
    // Note: I removed the redundant inner 'const' keywords for cleaner code
    //Index 0
    LearningTopic(
      title: 'WHAT IS E-WASTE ?',
      content:
          'Electrical or electronic devices are broken and no longer need anymore. It is highly toxic.',
      imagePath: 'assets/e-waste.jpg',
    ),
    //Index 1
    LearningTopic(
      title: 'HOW TO DISPOSAL ?',
      content:
          'Always dispose of e-waste at designated collection points or recycling bins, never in regular trash.',
      imagePath: 'assets/howtodisposal.jpg',
    ),
    //Index 2
    LearningTopic(
      title: 'WHY RECYCLE?',
      content:
          'Recycling saves valuable raw materials and prevents harmful substances from polluting the environment.',
      imagePath: 'assets/whyrecycle.jpg',
    ),
    //Index 3
    LearningTopic(
      title: 'CLOSING THE LOOP: VALUE IN WASTE',
      content:
          'E-waste contains valuable resources like **Gold, Copper, and Palladium**. Recycling these materials is cheaper than mining new ones, and saves tremendous energy. Before disposing of old gadgets, always perform a **Factory Reset** to erase personal data.',
      imagePath: 'assets/recyclebin.jpg',
    ),
    //Index 4
    LearningTopic(
      title: 'THE HARD STUFF: BATTERIES & BULBS',
      content:
          'Never discard batteries (especially Lithium-Ion) in regular trash due to fire risk. Put **clear tape over the terminals** of old batteries before placing them in specialized bins. Fluorescent and CFL bulbs contain mercury and also require special handling.',
      imagePath: 'assets/batteries_bulbs.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // 💡 LOGIK TAPISAN EFEKTIF
    final List<LearningTopic> topicsToDisplay;

    // Semak jika index dihantar DAN index itu sah
    if (initialTopicIndex != null &&
        initialTopicIndex! >= 0 &&
        initialTopicIndex! < _alltopics.length) {
      // Hanya paparkan satu topik yang dipilih
      topicsToDisplay = [_alltopics[initialTopicIndex!]];
    } else {
      // Paparkan semua topik
      topicsToDisplay = _alltopics;
    }
    return Scaffold(
      backgroundColor: backgroundWhite,

      // 1. Custom App Bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: _buildCustomAppBar(context),
      ),
      // 2. Body with Learning Cards
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: topicsToDisplay.map((topic) {
            // 👈 FOKUS UTAMA DI SINI
            return _buildContentCard(context, topic);
          }).toList(),
        ),
      ),

      // 3. Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavBar(context, 2), // Index 2 is 'Learn'
    );
  }

  // --- Widget Builders ---

  // Reusable card widget for learning topics
  Widget _buildContentCard(BuildContext context, LearningTopic topic) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: cardGreen,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Left side: Image (fixed-size box so all image tiles are the same)
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage(topic.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),

          // Right side: Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  topic.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: secondaryGreenText,
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(
                  color: secondaryGreenText,
                  height: 10,
                  thickness: 1.0,
                  endIndent: 80,
                ),

                // Content Text
                Text(
                  topic.content,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // 💡 FIX 1: App Bar with Rounded Shape Added
  // ----------------------------------------------------------------------
  Widget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundWhite,
      elevation: 0,
      toolbarHeight: 80.0,
      automaticallyImplyLeading: false,

      // ADDED: Rounded bottom corner shape
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      // ADDED: Leading back button (essential for Learn page navigation)
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: secondaryGreenText),
        onPressed: () => Navigator.of(context).pop(),
      ),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // The original design has the logo and title centered, and the image on the right
        children: <Widget>[
          // Logo & App Name (Moved slightly left to accommodate the back button)
          Row(
            children: [
              Image.asset('assets/ecoloop_logo.png', height: 60),
              const SizedBox(width: 8),
            ],
          ),

          // Profile Picture
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: primaryGreen, width: 2),
                image: const DecorationImage(
                  image: AssetImage('assets/profile_pic.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // 💡 FIX 2: Corrected Bottom Navigation Logic
  // ----------------------------------------------------------------------
  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundWhite,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 5.0),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: backgroundWhite,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        showUnselectedLabels: true,
        currentIndex: currentIndex,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            activeIcon: Icon(Icons.location_on),
            label: 'BIN LOCATOR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb), // Active icon for the current page
            activeIcon: Icon(Icons.lightbulb),
            label: 'LEARN',
          ),
        ],
        onTap: (index) {
          // Navigates using the routes defined in main.dart
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (index == 1) {
            // 👈 Changed from 2 to 1 (Bin Locator)
            Navigator.of(context).pushReplacementNamed('/bins');
          }
          // Index 2 is the current page, so no navigation needed
        },
      ),
    );
  }

  // ----------------------------------------------------------------------
}
