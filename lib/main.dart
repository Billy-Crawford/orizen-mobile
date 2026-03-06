// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_router.dart';

void main() {
  runApp(const ProviderScope(child: OrizenApp()));
}

class OrizenApp extends StatelessWidget {
  const OrizenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orizen',
      debugShowCheckedModeBanner: false,

      initialRoute: "/",
      routes: AppRouter.routes,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
    );
  }
}

