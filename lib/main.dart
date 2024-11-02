import 'package:flowtime/core/theme/theme.dart';
import 'package:flowtime/presentation/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  runApp(const ProviderScope(child: EzNutri()));
}

class EzNutri extends StatelessWidget {
  const EzNutri({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedMaterialApp(
      home: HomePage(),
    );
  }
}
