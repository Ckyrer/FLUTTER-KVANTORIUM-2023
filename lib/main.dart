import 'package:flutter/material.dart';
import 'package:shopping_list/pages/card_hidden_animation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CardHiddenAnimationPage()
      // home: Scaffold(
      //   body: Center(
      //     child: ComplexAnimatedContainerWidget(),
      //   ),
      // ),
    );
  }
}
