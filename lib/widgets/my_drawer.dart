import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/controller/user_controller.dart';
import 'package:form_validation/screens/login_screen.dart';
import 'package:form_validation/screens/wishlist_screen.dart';
import 'package:get/get.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final UserController _userController = Get.put(UserController());

  String phone = '';
  String address = '';

  @override
  void initState() {
    super.initState();
  }

  void _showEditDialog({
    required String title,
    required String currentValue,
    required Function(String) onSave,
    required String hint,
  }) {
    TextEditingController controller = TextEditingController(
      text: currentValue,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hint),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: Colors.orangeAccent,
          child: Obx(() {
            final user = _userController.currentuser.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drawer Header
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.orangeAccent,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            user != null && user.profileImageUrl.isNotEmpty
                            ? NetworkImage(user.profileImageUrl)
                            : const NetworkImage(
                                'https://tse4.mm.bing.net/th?id=OIP.7FsDgas0kcH0W1ajb1rZEgHaHa&pid=Api&P=0&h=180',
                              ),
                      ),

                      const SizedBox(height: 10),
                      Text(
                        user?.userName ?? 'Hello, User!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        user?.email ?? 'user@example.com',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(color: Colors.white54),

                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.white),
                  title: Text(
                    user?.phone != null && user!.phone.isNotEmpty
                        ? user.phone
                        : 'Add Phone',
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      _showEditDialog(
                        title: 'Phone',
                        currentValue: phone,
                        hint: 'Enter new phone number',
                        onSave: (value) {
                          setState(() => phone = value);
                          _userController.updateUserField('phone', value);
                        },
                      );
                    },
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.white),
                  title: Text(
                    user?.address != null && user!.address.isNotEmpty
                        ? user.address
                        : 'Add Address',
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      _showEditDialog(
                        title: 'Address',
                        currentValue: address,
                        hint: 'Enter new address',
                        onSave: (value) {
                          setState(() => address = value);
                          _userController.updateUserField('address', value);
                        },
                      );
                    },
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.white),
                  title: const Text(
                    'WishList',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WishlistScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text(
                    'Settings',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    _userController.isLogin.value=false;
                    _userController.currentuser.value=null;
                    Navigator.of(context).pop();

                  
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
