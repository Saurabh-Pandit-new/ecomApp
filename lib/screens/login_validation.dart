import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/controller/user_controller.dart';
import 'package:form_validation/model/user_model.dart';
import 'package:form_validation/service/user_service.dart';

class LoginValidation extends StatefulWidget {
  const LoginValidation({Key? key}) : super(key: key);

  @override
  State<LoginValidation> createState() => _LoginValidationState();
}

class _LoginValidationState extends State<LoginValidation>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _userController = UserController();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final imageUrlController = TextEditingController();

  String selectedRole = 'user';
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));
    _scaleAnimation =
        Tween<double>(begin: 0.95, end: 1).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutBack));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final uid = credential.user!.uid;

        UserModel newUser = UserModel(
          userId: uid,
          userName: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          address: addressController.text.trim(),
          profileImageUrl: imageUrlController.text.trim(),
          role: selectedRole,
          wishlist: [],
          cartlist: [],
        );

        await UserService().addUser(newUser);
        _userController.currentuser.value = newUser;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),

                              _buildTextField(nameController, 'Name', Icons.person, validator: (val) {
                                if (val == null || val.isEmpty) return 'Enter name';
                                if (val.contains(RegExp(r'[0-9]'))) return 'Enter valid name';
                                return null;
                              }),

                              _buildTextField(emailController, 'Email', Icons.email,
                                  validator: (val) => val == null || !val.contains('@') ? 'Enter valid email' : null),

                              _buildTextField(passwordController, 'Password', Icons.lock,
                                  isObscure: true,
                                  validator: (val) => val == null || val.length < 6 ? 'Min 6 characters' : null),

                              _buildTextField(phoneController, 'Phone', Icons.phone, validator: (val) {
                                if (val == null || val.length != 10) return 'Enter 10 digit phone number';
                                return null;
                              }),

                              _buildTextField(addressController, 'Address', Icons.home,
                                  validator: (val) => val == null || val.isEmpty ? 'Enter address' : null),

                              _buildTextField(imageUrlController, 'Image URL', Icons.image,
                                  validator: (val) => val == null || val.isEmpty ? 'Enter image URL' : null),

                              const SizedBox(height: 10),

                              DropdownButtonFormField<String>(
                                value: selectedRole,
                                decoration: _inputDecoration('Select Role'),
                                items: ['admin', 'user'].map((role) {
                                  return DropdownMenuItem(value: role, child: Text(role));
                                }).toList(),
                                onChanged: (val) => setState(() => selectedRole = val!),
                              ),

                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _isLoading ? null : registerUser,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.deepOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.deepOrange)
                                    : const Text("Register", style: TextStyle(fontSize: 16)),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.deepOrange),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool isObscure = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepOrange),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
