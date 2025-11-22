import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Custom Colors (Ensure these are defined consistently across your app) ---
const Color primaryGreen = Color(0xFF558B5C); // Main button/accent green
const Color cardGreen = Color(
  0xFFC7DAB8,
); // Muted green for the info card background
const Color secondaryGreenText = Color(
  0xFF4A7451,
); // Darker green for header/text
const Color backgroundWhite = Color(0xFFFFFFFF);
const Color deleteRed = Color(0xFFD32F2F); // Red for a clear "delete" action

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'User Name'; // Default name
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User Name';
    });
  }

  Future<void> _saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    setState(() {
      userName = name;
    });
  }

  void _showEditNameDialog() {
    _nameController.text = userName;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Enter your name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_nameController.text.trim().isNotEmpty) {
                _saveUserName(_nameController.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhite,

      // 1. Custom App Bar
      appBar: AppBar(
        backgroundColor: backgroundWhite,
        elevation: 0,
        toolbarHeight: 60.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondaryGreenText),
          onPressed: () => Navigator.of(context).pop(), // Navigate back
        ),
        title: const Text(
          'PROFILE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: secondaryGreenText,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: secondaryGreenText),
            onPressed: () {
              // TODO: Implement Log out logic
              debugPrint('User Logged Out');
            },
          ),
        ],
      ),

      // 2. Main Body Content
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),

            // 3. Profile Picture
            _buildProfilePicture(),
            const SizedBox(height: 15),

            // 4. User Name with Edit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: secondaryGreenText,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit, color: primaryGreen, size: 20),
                  onPressed: _showEditNameDialog,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Edit name',
                ),
              ],
            ),
            const SizedBox(height: 25),

            // 5. Delete Account Button
            _buildDeleteAccountButton(context),
            const SizedBox(height: 30),

            // 6. User Information Card (The large green box)
            _buildUserInfoCard(context),
          ],
        ),
      ),
    );
  }

  // --- Widget Builder Helpers ---

  Widget _buildProfilePicture() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: primaryGreen, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage(
            'assets/profile_large.jpg',
          ), // ⚠️ Replace with actual image path
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.warning_rounded, color: deleteRed),
                    SizedBox(width: 8),
                    Text('Delete Account', style: TextStyle(color: deleteRed)),
                  ],
                ),
                content: const Text(
                  'Are you sure you want to delete your account? This action cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      // TODO: Implement account deletion logic here

                      // Close the confirmation dialog
                      Navigator.pop(context);

                      // Show success dialog
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Row(
                              children: [
                                Icon(Icons.check_circle, color: deleteRed),
                                SizedBox(width: 8),
                                Text('Account Deleted'),
                              ],
                            ),
                            content: const Text(
                              'Your account has been successfully deleted.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Close the success dialog and navigate to signup page
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/signup',
                                    (Route<dynamic> route) =>
                                        false, // Remove all previous routes
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: deleteRed,
                                ),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: TextButton.styleFrom(foregroundColor: deleteRed),
                    child: const Text('Delete'),
                  ),
                ],
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: deleteRed, // Use red for destructive action
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 3,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'DELETE ACCOUNT',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: backgroundWhite,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: cardGreen, // Muted green background for the card
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // USER INFORMATION Header
          const Text(
            'USER INFORMATION',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: secondaryGreenText,
            ),
          ),
          const SizedBox(height: 20),

          // --- USERNAME Field ---
          _buildInfoLabel('USERNAME:'),
          _buildReadOnlyTextField(placeholder: 'Syazana Rafi'),
          const SizedBox(height: 15),

          // --- EMAIL Field ---
          _buildInfoLabel('EMAIL:'),
          _buildReadOnlyTextField(placeholder: 'alyazana87@gmail.com'),
          const SizedBox(height: 15),

          // --- NEW PASSWORD Field ---
          _buildInfoLabel('NEW PASSWORD (OPTIONAL):'),
          _buildEditableTextField(isPassword: true),
          const SizedBox(height: 30),

          // --- SAVE CHANGES Button ---
          Center(
            child: SizedBox(
              height: 50,
              width: 200, // Fixed width for a centered button
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Changes'),
                        content: const Text(
                          'Are you sure you want to save these changes?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              // TODO: Implement save logic here

                              // Show success dialog
                              Navigator.pop(
                                context,
                              ); // Close confirmation dialog
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: primaryGreen,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Success'),
                                      ],
                                    ),
                                    content: const Text(
                                      'Changes saved successfully!',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: TextButton.styleFrom(
                                          foregroundColor: primaryGreen,
                                        ),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: primaryGreen,
                            ),
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'SAVE CHANGES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: backgroundWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable label for info fields
  Widget _buildInfoLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: secondaryGreenText,
        ),
      ),
    );
  }

  // Reusable text field for data that is displayed (Username, Email)
  Widget _buildReadOnlyTextField({required String placeholder}) {
    return TextField(
      enabled: false,
      controller: TextEditingController(text: placeholder),
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 15.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(fontSize: 16, color: Colors.black54),
    );
  }

  // Reusable text field for editable input (New Password)
  Widget _buildEditableTextField({bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 15.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
