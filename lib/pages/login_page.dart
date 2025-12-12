import 'package:flutter/material.dart';
import 'home_page.dart'; // Impor halaman home

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk mengambil teks dari textfield
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // DATA HARDCODED
  final String _correctUsername = 'user';
  final String _correctPassword = '12345';


  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Cek apakah username dan password sesuai
    if (username == _correctUsername && password == _correctPassword) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Jika gagal, tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username atau Password salah!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 16),
              Text(
                'Selamat Datang',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Text('Masuk untuk melanjutkan'),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                // Data dummy untuk tes
                // controller: TextEditingController(text: 'user'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true, // Untuk menyembunyikan password
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                // Data dummy untuk tes
                // controller: TextEditingController(text: '12345'),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
