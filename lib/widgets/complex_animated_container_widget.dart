import 'package:flutter/material.dart';

class ComplexAnimatedContainerWidget extends StatefulWidget {
  const ComplexAnimatedContainerWidget({super.key});

  @override
  _ComplexAnimatedContainerWidgetState createState() => _ComplexAnimatedContainerWidgetState();
}

class _ComplexAnimatedContainerWidgetState extends State<ComplexAnimatedContainerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation; // Changed to Color?
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _sizeAnimation = Tween<double>(begin: 0, end: 200).animate(_controller);
    _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.red).animate(_controller); // Uncommented this line
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _rotationAnimation.value,
      child: Container(
        width: _sizeAnimation.value,
        height: _sizeAnimation.value,
        color: _colorAnimation.value,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}