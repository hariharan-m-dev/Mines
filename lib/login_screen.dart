import 'package:flutter/material.dart';

// ------------ FIX: THE MISSING STARTING POINT ------------
// Every Flutter app needs a main() function to start.
void main() {
  runApp(const SurakshaSaathiApp());
}

// This is the root widget of your application.
class SurakshaSaathiApp extends StatelessWidget {
  const SurakshaSaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp provides the core structure for navigation and theming.
    return MaterialApp(
      title: 'Suraksha Saathi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto', // Example font
      ),
      // We tell MaterialApp that our LoginScreen is the first page to show.
      home: const LoginScreen(),
      // You can define routes for navigation here later
      // routes: {
      //   '/role-selection': (context) => const RoleSelectionScreen(),
      // },
    );
  }
}
// -------------------- END OF FIX --------------------


// Your excellent LoginScreen code starts here - no changes needed below this line.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // In lib/login_screen.dart, inside the _LoginScreenState class

  void _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedRole == null || _selectedRole!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your role'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    // --- UPDATE THIS PART ---
    if (mounted) {
      // Navigate to the dashboard and pass the user's data
      Navigator.pushReplacementNamed(
        context,
        '/dashboard', // Use the route name we defined in main.dart
        arguments: {
          'email': _emailController.text,
          'role': _selectedRole,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0B1020),
              const Color(0xFF0F1730),
              const Color(0xFF0B1020),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and Title
                    _buildHeader(),
                    const SizedBox(height: 48),

                    // Login Card
                    _buildLoginCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo with gradient background
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF059669)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.shield,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        // App Name
        const Text(
          'Suraksha Saathi',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Mine Safety Companion',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.6),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111A33).withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Text
            const Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to access your safety dashboard',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),

            // Email Field
            _buildLabel('Email Address'),
            const SizedBox(height: 8),
            _buildEmailField(),
            const SizedBox(height: 20),

            // Password Field
            _buildLabel('Password'),
            const SizedBox(height: 8),
            _buildPasswordField(),
            const SizedBox(height: 20),

            // Role Dropdown
            _buildLabel('Role'),
            const SizedBox(height: 8),
            _buildRoleDropdown(),
            const SizedBox(height: 32),

            // Login Button
            _buildLoginButton(),

            const SizedBox(height: 16),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white.withOpacity(0.8),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'you@example.com',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: Colors.white.withOpacity(0.5),
        ),
        filled: true,
        fillColor: const Color(0xFF0F1730),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF10B981),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
          return 'Enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Colors.white.withOpacity(0.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.white.withOpacity(0.5),
          ),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
        filled: true,
        fillColor: const Color(0xFF0F1730),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF10B981),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      decoration: InputDecoration(
        hintText: 'Select your role',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        prefixIcon: Icon(
          Icons.person_outline,
          color: Colors.white.withOpacity(0.5),
        ),
        filled: true,
        fillColor: const Color(0xFF0F1730),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF10B981),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      dropdownColor: const Color(0xFF0F1730),
      style: const TextStyle(color: Colors.white),
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white.withOpacity(0.5),
      ),
      items: const [
        DropdownMenuItem(
          value: 'truck_driver',
          child: Text('Haul Truck Driver'),
        ),
        DropdownMenuItem(
          value: 'underground_miner',
          child: Text('Underground Miner'),
        ),
        DropdownMenuItem(
          value: 'blaster',
          child: Text('Blaster / Explosives Handler'),
        ),
        DropdownMenuItem(
          value: 'electrician',
          child: Text('Electrician / Maintenance Staff'),
        ),
        DropdownMenuItem(
          value: 'supervisor',
          child: Text('Supervisor / Safety Officer'),
        ),
      ],
      onChanged: (value) {
        setState(() => _selectedRole = value);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your role';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10B981),
          disabledBackgroundColor: const Color(0xFF10B981).withOpacity(0.5),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: const Color(0xFF10B981).withOpacity(0.5),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Divider(
            color: Colors.white.withOpacity(0.1),
            thickness: 1,
          ),
          const SizedBox(height: 16),
          Text(
            'Protected by enterprise-grade security',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Need help? Contact your system administrator',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}