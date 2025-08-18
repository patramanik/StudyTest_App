// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInCubic),
      ),
    );
    
    _controller.forward();
    
    // Navigate after animations complete
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Main animated title
                AnimatedTextKit(
                  animatedTexts: [
                    ScaleAnimatedText(
                      'StudyTest',
                      textStyle: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2962FF),
                        letterSpacing: 1.5,
                      ),
                      scalingFactor: 0.2,
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
                const SizedBox(height: 20),
                // Animated subtitle
                FadeIn(
                  controller: _controller,
                  delay: 800,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'Smart Learning. Better Results.',
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        speed: const Duration(milliseconds: 50),
                      ),
                    ],
                    totalRepeatCount: 1,
                  ),
                ),
                const SizedBox(height: 40),
                // Animated loading dots
                FadeIn(
                  controller: _controller,
                  delay: 1500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Dot(color: Colors.blue[400]!, delay: 0),
                      Dot(color: Colors.blue[500]!, delay: 200),
                      Dot(color: Colors.blue[600]!, delay: 400),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper widget for delayed fade-in
class FadeIn extends StatelessWidget {
  final AnimationController controller;
  final int delay;
  final Widget child;
  const FadeIn({
    super.key,
    required this.controller,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (controller.value * 2000 < delay) {
          return const SizedBox();
        }
        return Opacity(
          opacity: (controller.value * 2000 - delay) / (2000 - delay),
          child: child,
        );
      },
      child: child,
    );
  }
}

// Animated dot for loading indicator
class Dot extends StatefulWidget {
  final Color color;
  final int delay;

  const Dot({super.key, required this.color, required this.delay});

  @override
  _DotState createState() => _DotState();
}

class _DotState extends State<Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 8, end: 12).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _animation.value,
          height: _animation.value,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}