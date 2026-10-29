import 'package:flutter/material.dart';
import 'success_screen.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const _tipCategory = 'password_help';

  static const _presetTips = <String, String>{
    'password_help': 'Use a ling and unique password for the account',
    'account_help': 'Dont lose your email for recovery',
    'privacy_help': 'Dont share your password',
  };

  bool _loadingTip = false;
  bool _failNextTip = false;
  String? _tipText;
  String? _tipError;
  String? _selectedCreatureType;
  bool _obscurePassword = true;
  bool _submitting = false;

  DateTime? _birthDate;
  final TextEditingController _dateController = TextEditingController();

  Future<void> _getSignupTip() async {
    if (_loadingTip) return;

    final shouldFail = _failNextTip;

    setState(() {
      _loadingTip = true;
      _tipText = null;
      _tipError = null;
      _failNextTip = false;
    });

    await Future<void>.delayed(const Duration(seconds: 1), () {});

    if (!mounted) return;

    final tip = _presetTips[_tipCategory];

    setState(() {
      _loadingTip = false;

      if (shouldFail) {
        _tipError = 'Simulated tip error. Tap Retry.';
      } else if (tip == null || tip.trim().isEmpty || tip.length > 240) {
        _tipError = 'No valid preset tip is available.';
      } else {
        _tipText = tip;
      }
    });
  }

  Future<void> _submit() async {
  if (_submitting) return;
  if (!_formKey.currentState!.validate()) return;

  final userName = _nameController.text.trim();
  final creatureType = _selectedCreatureType!;

  setState(() {
    _submitting = true;
  });

  await Future<void>.delayed(const Duration(seconds: 2));

  if (!mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => SuccessScreen(
        userName: userName,
        creatureType: creatureType,
      ),
    ),
  );
}

@override
void dispose() {
  _nameController.dispose();
  _emailController.dispose();
  _passwordController.dispose();
  _dateController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 👨 Parent
      appBar: AppBar(
        title: const Text('Join Us Today for the Cash Money!'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // 👶 Child
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 👤 Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 📧 Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 🔒 Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be more than 6 letters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Birthdate',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                validator: (_) {
                  if (_birthDate == null) {
                    return 'Pick your birthday';
                  }
                  return null;
                },
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _birthDate ?? DateTime(2008),
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(),
                  );

                  if (!mounted || picked == null) return;

                  setState(() {
                    _birthDate = picked;
                    _dateController.text =
                        '${picked.month}/${picked.day}/${picked.year}';
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCreatureType,
                decoration: const InputDecoration(
                  labelText: 'Creature Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Ghost', child: Text('Ghost')),
                  DropdownMenuItem(value: 'Bat', child: Text('Bat')),
                  DropdownMenuItem(value: 'Vampire', child: Text('Vampire')),
                  DropdownMenuItem(
                    value: 'Headless Horsemen ',
                    child: Text('Headless Horsemen'),
                  ),
                  DropdownMenuItem(value: 'Jason', child: Text('Jason')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCreatureType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a creature ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 🚀 Sign Up Button
              ElevatedButton(
  onPressed: _submitting ? null : _submit,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    padding: const EdgeInsets.symmetric(
      horizontal: 50,
      vertical: 16,
    ),
  ),
  child: _submitting
      ? const SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
      : const Text(
          'Register Creature',
          style: TextStyle(fontSize: 18),
        ),
),

              const SizedBox(height: 24),
              const Divider(),

              const Text(
                'Preset demo tip—not live AI.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Simulate next tip error'),
                value: _failNextTip,
                onChanged: _loadingTip
                    ? null
                    : (value) {
                        setState(() {
                          _failNextTip = value;
                        });
                      },
              ),

              OutlinedButton(
                onPressed: _loadingTip ? null : _getSignupTip,
                child: Text(_loadingTip ? 'Loading tip.' : 'Get a signup tip'),
              ),

              if (_loadingTip)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),

              if (_tipText != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(_tipText!),
                ),

              if (_tipError != null) ...[
                Text(_tipError!, style: const TextStyle(color: Colors.red)),
                TextButton(
                  onPressed: _loadingTip ? null : _getSignupTip,
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
