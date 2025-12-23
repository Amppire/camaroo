import 'package:flutter/material.dart';
import 'package:camaroo/utils/app_constants.dart';
import 'package:camaroo/utils/theme_constants.dart';
import 'package:camaroo/ui/home.dart';
void main() {
  runApp(const Cameroo());
}

class Cameroo extends StatelessWidget {
  const Cameroo({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ThemeConstants.primaryColor),
      ),
      home: const HomePage(title: AppConstants.appName),
    );
  }
}


