import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'cubit/bloc_observer.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'my_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: ThemeData.light(),
      builder: (p0, theme) {
        return MaterialApp(
          title: 'IoT pH',
          theme: theme,
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        );
      },
    );
  }
}
