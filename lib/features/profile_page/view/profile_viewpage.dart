import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shopping_app/features/profile_page/view/change_password_viewpage.dart';
import '../../auth/data/model/user_hive_model.dart';
import '../../auth/presentation/view/login_view.dart';
import 'order_history_viewpage.dart';
import 'profile_edit_viewpage.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBox = Hive.box<UserHiveModel>('authBox');
    final userHiveModel = authBox.get('currentUser');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Colors.white],
          ),
        ),
        child: userHiveModel == null
            ? Center(
                child: Text('No user data available. Please log in.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              )
            : Column(
                children: [
                  SizedBox(height: 80),
                  // Profile Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                NetworkImage(userHiveModel.user.avatar.url),
                            backgroundColor: Colors.grey[300],
                          ),
                          SizedBox(height: 15),
                          Text(userHiveModel.user.name,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87)),
                          SizedBox(height: 5),
                          Text(userHiveModel.user.email,
                              style: TextStyle(fontSize: 16, color: Colors.grey)),
                          SizedBox(height: 5),
                          Text("Joined: ${userHiveModel.user.createdAt}",
                              style: TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Profile Menu Options
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: ListView(
                        children: [
                          _buildProfileMenuItem(Icons.edit, 'Edit Profile',
                              () => _navigate(context, ProfileEditPage())),
                          _buildProfileMenuItem(Icons.lock, 'Change Password',
                              () => _navigate(context, ChangePasswordPage(resetToken: ""))),
                          _buildProfileMenuItem(Icons.history, 'Order History',
                              () => _navigate(context, OrderHistoryPage())),
                          _buildProfileMenuItem(Icons.privacy_tip, 'Privacy Policy', () {}),
                          _buildProfileMenuItem(Icons.description, 'Terms & Conditions', () {}),
                          Divider(),
                          SizedBox(height: 10),
                          Center(
                            child: ElevatedButton(
                              onPressed: () => _logout(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text('Logout',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildProfileMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: TextStyle(fontSize: 18)),
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final authBox = Hive.box<UserHiveModel>('authBox');
              await authBox.delete('currentUser');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false,
              );
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
