import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_praktikum/views/auth/Login.dart';
import 'package:project_praktikum/views/MediaCategories.dart';
import 'package:project_praktikum/views/MediaCategoriesHome.dart';
import 'BottomNavBar.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profile> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logout successful!'), backgroundColor: Colors.green,),
    );
  }

  Future<User?> _getUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');

      await storageRef.putFile(_image!);
      final imageUrl = await storageRef.getDownloadURL();

      // await user.photoURL(photoURL: imageUrl);
      await user.updateProfile(photoURL: imageUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile picture updated!'), backgroundColor: Colors.green,),
      );

      setState(() {});
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e'), backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildProfileContent(context),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.newspaper,
              size: 30,
              color: Colors.red[500],
            ),
          ),
          SizedBox(width: 10),
          Text(
            'SIBAS NEWS!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return FutureBuilder<User?>(
      future: _getUser(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          User user = snapshot.data!;
          String? displayName = user.displayName;
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        user.photoURL ?? 'https://via.placeholder.com/150',
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    displayName ?? 'No display name',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    user.email ?? '@username',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Divider(color: Colors.grey),
                _buildListTile(
                  icon: Icons.person,
                  text: 'Account Info',
                  onTap: () {
                    // Aksi untuk Account Info
                  },
                ),
                Divider(color: Colors.grey),
                _buildListTile(
                  icon: Icons.settings,
                  text: 'Settings',
                  onTap: () {
                    // Aksi untuk Settings
                  },
                ),
                Divider(color: Colors.grey),
                _buildListTile(
                  icon: Icons.account_balance_rounded,
                  text: 'Choose Media',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediaCategoriesHome(),
                      ),
                    );
                  },
                ),
                Divider(color: Colors.grey),
                SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: () => _signOut(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontStyle: FontStyle.normal),
                  ),
                  child: _buildListTile(
                    icon: Icons.logout,
                    text: 'Logout',
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    onTap: () => _signOut(context),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No user data available'));
        }
      },
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color iconColor = Colors.blueAccent,
    Color textColor = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(text, style: TextStyle(color: textColor)),
      onTap: onTap,
    );
  }
}
