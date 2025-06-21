import 'package:flutter/material.dart';

class BlinkingTab extends StatefulWidget {
  final IconData icon;
  final String label;

  const BlinkingTab({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  _BlinkingTabState createState() => _BlinkingTabState();
}

class _BlinkingTabState extends State<BlinkingTab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.orange,
      end: Colors.black,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Tab(
          icon: Icon(widget.icon, color: _colorAnimation.value),
          child: Text(widget.label, style: TextStyle(color: _colorAnimation.value)),
        );
      },
    );
  }
}
