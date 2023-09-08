import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/my_data_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});
  
    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
        create: (context) => MyDataProvider()..getData(),
        child: MaterialApp(
          title: 'My App',
          theme: ThemeData(
       // ! Теперь можно использовать новые компоненты из Material 3
       // ! И наконец-то выбирать любой цвет какой мы захотим для темы приложения
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 62, 183, 58),
            ),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        ),
      );
    }
  }
