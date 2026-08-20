import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'feature/presentation/views/home_page.dart';
import 'feature/presentation/views/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    bool isLoggedIn = box.read('isLoggedIn') ?? false;

    return GetMaterialApp(
      title: 'GetX Product App',
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
