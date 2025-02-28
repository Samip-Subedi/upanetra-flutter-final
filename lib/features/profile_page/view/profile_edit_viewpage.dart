import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../auth/data/model/user_hive_model.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _avatarUrlController;
  UserHiveModel? _userHiveModel;

  @override
  void initState() {
    super.initState();
    final authBox = Hive.box<UserHiveModel>('authBox');
    _userHiveModel = authBox.get('currentUser');
    _nameController = TextEditingController(text: _userHiveModel?.user.name ?? '');
    _avatarUrlController = TextEditingController(text: _userHiveModel?.user.avatar.url ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_userHiveModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user data to update')),
      );
      return;
    }

    final authBox = Hive.box<UserHiveModel>('authBox');
    final updatedUser = UserHiveModel(
      success: _userHiveModel!.success,
      user: UserData(
        avatar: Avatar(
          publicId: _userHiveModel!.user.avatar.publicId, // Keep original publicId
          url: _avatarUrlController.text.trim(),
        ),
        id: _userHiveModel!.user.id,
        name: _nameController.text.trim(),
        email: _userHiveModel!.user.email, // Email not editable here
        password: _userHiveModel!.user.password, // Password not editable here
        role: _userHiveModel!.user.role,
        createdAt: _userHiveModel!.user.createdAt,
      ),
      token: _userHiveModel!.token,
    );

    await authBox.put('currentUser', updatedUser);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully')),
    );
    Navigator.pop(context); // Return to ProfilePage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: _userHiveModel == null
          ? Center(child: Text('No user data available. Please log in.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar Preview
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_avatarUrlController.text),
                        onBackgroundImageError: (exception, stackTrace) =>
                            Icon(Icons.person, size: 50),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Name Field
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Avatar URL Field
                    TextField(
                      controller: _avatarUrlController,
                      decoration: InputDecoration(
                        labelText: 'Avatar URL',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Save Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}