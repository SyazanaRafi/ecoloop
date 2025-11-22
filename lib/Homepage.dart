import 'package:flutter/material.dart';
import 'BinLocator.dart';
import 'Profile.dart';
import 'Learn.dart';

// --- Custom Colors ---
const Color primaryGreen = Color(0xFF558B5C); // Main accent green (Dark)
const Color lightGreen = Color(
  0xFFC7DAB8,
); // Light green for welcome card (Muted)
const Color secondaryGreenText = Color(0xFF4A7451); // Darker green text
const Color backgroundWhite = Color(0xFFFFFFFF);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // --- Static Widget Builders ---

  // 1. Custom AppBar with Rounded Bottom (Shape added)
  static Widget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundWhite,
      elevation: 0,
      toolbarHeight: 80.0,
      automaticallyImplyLeading: false,

      // ADDED: Rounded shape for visual appeal
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Logo (EcoLoop Infinity)
          Row(
            children: [
              Image.asset('assets/ecoloop_logo.png', height: 60),
              const SizedBox(width: 8),
            ],
          ),
          // Profile Picture (Clickable)
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

  // 2. Enhanced Welcome Card (Gradient removed, shadow/color retained)
  static Widget _buildWelcomeCard(String name) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      decoration: BoxDecoration(
        // COLOR: Reverting to original lightGreen, but keeping the box shadow for 'lift'
        color: lightGreen,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, $name',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: secondaryGreenText, // Reverted to original text color
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Welcome to EcoLoop',
            style: TextStyle(
              fontSize: 18,
              color: secondaryGreenText,
            ), // Reverted to original text color
          ),
        ],
      ),
    );
  }

  // 3. Find Nearest Bin Button (Unchanged)
  static Widget _buildFindBinButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BinLocatorPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: lightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 3,
        ),
        icon: const Icon(Icons.search, color: secondaryGreenText),
        label: const Text(
          'FIND NEAREST BIN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: secondaryGreenText,
          ),
        ),
      ),
    );
  }

  // 4. Info Card with enhancements (Structural Layering Retained)
  static Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.5,
        // ADDED: Stack for visual layering/icon
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: <Widget>[
                // Image Container (Top half)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15.0),
                    ),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 100,
                  width: double.infinity,
                ),
                // Text Container (Bottom half)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 5.0,
                  ),
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(
                      0.5,
                    ), // Reverted to use primaryGreen with opacity
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          backgroundWhite, // Keeping white text for contrast on dark green
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            // Floating Lightbulb Icon
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(Icons.lightbulb, color: backgroundWhite, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  // 5. Bottom Navigation Bar (Unchanged)
  static Widget _buildBottomNavBar(BuildContext context) {
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
        currentIndex: 0,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'BIN LOCATOR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'LEARN',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BinLocatorPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LearnPage()),
            );
          }
        },
      ),
    );
  }

  // --- Main Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhite,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: _buildCustomAppBar(context),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            _buildWelcomeCard('User'),
            const SizedBox(height: 30),

            const Text(
              'DID YOU KNOW ?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: secondaryGreenText,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You can recycle your old phone batteries at the e-waste bin ?',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 25),

            _buildFindBinButton(context),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildInfoCard(
                  context: context,
                  title: 'WHAT IS E\n-WASTE ?',
                  imagePath: 'assets/e-waste.jpg',
                  onTap: () {
                    // Navigate to Learn page and show only the first topic (WHAT IS E-WASTE)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LearnPage(initialTopicIndex: 0),
                      ),
                    );
                  },
                ),
                _buildInfoCard(
                  context: context,
                  title: 'HOW TO\nDISPOSAL ?',
                  imagePath: 'assets/howtodisposal.jpg',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LearnPage(initialTopicIndex: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildInfoCard(
                  context: context,
                  title: 'WHY \nRECYCLE ?',
                  imagePath: 'assets/whyrecycle.jpg',
                  onTap: () {
                    // Navigate to Learn page and show only the first topic (WHAT IS E-WASTE)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LearnPage(initialTopicIndex: 2),
                      ),
                    );
                  },
                ),
                _buildInfoCard(
                  context: context,
                  title: 'THE HARD STUFF:\n BATTERIES & BULBS',
                  imagePath: 'assets/batteries_bulbs.jpg',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LearnPage(initialTopicIndex: 4),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }
}
