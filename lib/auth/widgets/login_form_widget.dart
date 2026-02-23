import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/auth/login_provider.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class LoginFormWidget extends StatelessWidget {
  final TextEditingController ctrlNPM;
  final TextEditingController ctrlPassword;

  const LoginFormWidget({
    Key? key,
    required this.ctrlNPM,
    required this.ctrlPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NPM',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        _buildField(
          controller: ctrlNPM,
          hint: 'Nomor Pokok Mahasiswa',
          icon: LineIcons.user,
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 20),
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        _buildPasswordField(
          controller: ctrlPassword,
          obscureText: loginProvider.isObscureText,
          onToggleObscure: () =>
              loginProvider.setIsObscureText = !loginProvider.isObscureText,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              // Lupa password - hubungi admin (info only)
            },
            child: Text(
              'Lupa Password? Hubungi Admin.',
              style: TextStyle(
                color: config.colorPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        cursorColor: config.colorPrimary,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.black.withOpacity(0.5), size: 20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleObscure,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              cursorColor: config.colorPrimary,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Kata Sandi',
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 14),
                prefixIcon: Icon(
                  LineIcons.key,
                  color: Colors.black.withOpacity(0.5),
                  size: 20,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          GestureDetector(
            onTap: onToggleObscure,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                obscureText ? LineIcons.eye : Icons.visibility_off,
                color: Colors.black.withOpacity(0.5),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
