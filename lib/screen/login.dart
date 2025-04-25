import 'package:flutter/material.dart';
import 'package:note/screen/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isButtonEnabled = false;

  // Daftar user
  final List<Map<String, String>> users = [
    {
      'name': 'Rifqi Fauzan',
      'email': 'user1@example.com',
      'password': '123456',
    },
    {
      'name': 'Adzikra',
      'email': 'user2@example.com',
      'password': 'passwordku',
    },
  ];

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> _saveUserData(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  // ignore: unused_element
  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final inputEmail = _emailController.text.trim();
      final inputPassword = _passwordController.text;

      final user = users.firstWhere(
        (user) => user['email'] == inputEmail && user['password'] == inputPassword,
        orElse: () => {},
      );

      if (user.isNotEmpty) {
        await _saveUserData(user['name']!, user['email']!, user['password']!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login berhasil!')),
        );
        // Navigasi ke halaman utama jika ada
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email atau Password salah')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.lock_outline, size: 80, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  'Welcome',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Masukkan Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                  onChanged: (value) => _validateForm(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Masukkan Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                  onChanged: (value) => _validateForm(),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();

                          // Cek apakah email dan password cocok
                          final matchedUser = users.firstWhere(
                            (user) =>
                                user['email'] == email && user['password'] == password,
                            orElse: () => {},
                          );

                          if (matchedUser.isNotEmpty) {
                            // Jika cocok, pindah ke halaman Home
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const NotePage()),
                            );
                          } else {
                            // Jika tidak cocok, tampilkan error
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email atau password salah'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Login", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
