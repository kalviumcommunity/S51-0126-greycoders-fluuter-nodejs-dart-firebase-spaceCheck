import 'package:flutter/material.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const GreyscalerApp());
}

class GreyscalerApp extends StatelessWidget {
  const GreyscalerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greyscaler',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Applied our custom dark theme
      home: const Scaffold(
        body: Center(
          child: Text('Greyscaler Setup Complete'),
        ),
      ),
    );
  }
}
