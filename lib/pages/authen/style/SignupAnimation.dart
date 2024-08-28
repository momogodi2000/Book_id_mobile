import 'package:flutter/material.dart';

class SignupAnimation extends StatefulWidget {
  final Widget child;

  const SignupAnimation({Key? key, required this.child}) : super(key: key);

  @override
  _SignupAnimationState createState() => _SignupAnimationState();
}

class _SignupAnimationState extends State<SignupAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}