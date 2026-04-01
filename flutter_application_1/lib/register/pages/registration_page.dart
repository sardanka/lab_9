import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../bloc/register_bloc.dart';
import '../bloc/register_event.dart';
import '../bloc/register_state.dart';
import '../../rest_client/profile.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _lifeStoryController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _lifeStoryFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _lifeStoryController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _lifeStoryFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? value) =>
      (value == null || value.trim().isEmpty) ? 'Name cannot be empty' : null;

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number cannot be empty';
    if (!RegExp(r'^\d+$').hasMatch(value.trim())) return 'Phone number must contain only digits';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email cannot be empty';
    final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty';
    if (value.length < 6) return 'Minimum 6 characters required';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(LoadProfileEvent());
    }
  }

  Widget _topRoundedField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String? Function(String?) validator,
    required TextInputAction textInputAction,
    required VoidCallback onDelete,
    required void Function(String) onFieldSubmitted,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 1.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixIcon: IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.deepOrangeAccent),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }

  Widget _underlinedField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
    String? Function(String?)? validator,
    required TextInputAction textInputAction,
    required void Function(String) onFieldSubmitted,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      maxLength: maxLength,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        labelText: label,
        suffixIcon: suffixIcon,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) async {
        if (state is RegisterLoaded) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Center(
              child: Lottie.asset(
                'assets/lottie/success.json',
                width: 160,
                height: 160,
                repeat: false,
              ),
            ),
          );

          await Future.delayed(const Duration(seconds: 1));

          if (context.mounted) {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => UserInfoPage(profile: state.profile),
              ),
            );
          }
        } else if (state is RegisterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register Form',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _topRoundedField(
                    label: 'Full Name *',
                    icon: Icons.person,
                    controller: _nameController,
                    focusNode: _nameFocus,
                    validator: _validateName,
                    textInputAction: TextInputAction.next,
                    onDelete: () => _nameController.clear(),
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_phoneFocus),
                  ),
                  const SizedBox(height: 14),
                  _topRoundedField(
                    label: 'Phone Number *',
                    icon: Icons.phone,
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    validator: _validatePhone,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.next,
                    onDelete: () => _phoneController.clear(),
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
                  ),
                  const SizedBox(height: 18),
                  _underlinedField(
                    label: 'Email Address',
                    icon: Icons.email,
                    controller: _emailController,
                    focusNode: _emailFocus,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_lifeStoryFocus),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _lifeStoryController,
                    focusNode: _lifeStoryFocus,
                    minLines: 4,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Life Story',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _underlinedField(
                    label: 'Password *',
                    icon: Icons.security,
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    validator: _validatePassword,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    maxLength: 8,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_confirmPasswordFocus),
                  ),
                  _underlinedField(
                    label: 'Confirm Password *',
                    icon: Icons.edit,
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    validator: _validateConfirmPassword,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    maxLength: 8,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        if (state is RegisterLoading) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Lottie.asset(
                                  'assets/lottie/loading.json',
                                  width: 120,
                                  height: 100,
                                ),
                                const SizedBox(height: 16),
                                const Text('Signing in...'),
                              ],
                            ),
                          );
                        }

                        return ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66BB6A),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Submit Form'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserInfoPage extends StatelessWidget {
  final Profile profile;

  const UserInfoPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Info')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${profile.id}', style: const TextStyle(fontSize: 18)),
            Text('User ID: ${profile.userId}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text('Title: ${profile.title}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text('Body: ${profile.body}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}