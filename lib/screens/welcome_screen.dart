import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // State variable to toggle
  bool _isActive = false;
  Color _iconColor = Colors.blue;

  void _toggleState() {
    setState(() {
      _isActive = !_isActive;
      _iconColor = _isActive ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to GreyScaler'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            const Text(
              'Hello, Resident!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Image/Icon
            Icon(
              Icons.home_work_rounded,
              size: 100,
              color: _iconColor,
            ),
            const SizedBox(height: 20),
            
            // State display
            Text(
              _isActive ? 'Status: Active' : 'Status: Inactive',
              style: TextStyle(
                fontSize: 18,
                color: _isActive ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            
            // Interaction Button
            ElevatedButton.icon(
              onPressed: _toggleState,
              icon: const Icon(Icons.touch_app),
              label: const Text('Toggle Status'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
