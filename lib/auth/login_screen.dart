import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_mobile/auth/login_provider.dart';
import 'package:sisfo_mobile/auth/widgets/login_form_widget.dart';
import 'package:sisfo_mobile/home/home_screen.dart';
import 'package:sisfo_mobile/services/global_config.dart';
import 'package:sisfo_mobile/widgets/logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> _handleLogin(
      BuildContext context, LoginProvider loginProvider) async {
    final npm = loginProvider.ctrlNPM.text.trim();
    final password = loginProvider.ctrlPassword.text;
    if (npm.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'NPM dan Password tidak boleh kosong!');
      return;
    }
    await loginProvider.doLogin(login: npm, password: password);
    if (!context.mounted) return;
    if (loginProvider.stateLogin == StateLogin.loaded) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LoginProvider>().initial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.read<LoginProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 42),
              LogoWidget(width: 120, height: 120),
              const SizedBox(height: 12),
              Text(
                config.textTitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: config.colorPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Selamat datang, masuk ke akun Anda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.85),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LoginFormWidget(
                      ctrlNPM: loginProvider.ctrlNPM,
                      ctrlPassword: loginProvider.ctrlPassword,
                    ),
                    const SizedBox(height: 24),
                    Selector<LoginProvider, StateLogin>(
                      selector: (_, p) => p.stateLogin,
                      builder: (_, state, __) => _LoginButton(
                        isLoading: state == StateLogin.loading,
                        onPressed: () => _handleLogin(context, loginProvider),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _LoginButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: config.colorPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          isLoading ? 'Memuat...' : 'Login',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
