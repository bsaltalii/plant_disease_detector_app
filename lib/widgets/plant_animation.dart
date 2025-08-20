import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PlantAnimation extends StatefulWidget {
  const PlantAnimation({super.key});

  @override
  State<PlantAnimation> createState() => _PlantAnimationState();
}

class _PlantAnimationState extends State<PlantAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _forward = true; // yön takibi

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(milliseconds: 100));
        _forward = false;
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        await Future.delayed(const Duration(milliseconds: 100));
        _forward = true;
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      child: Align(
        alignment: Alignment.center,
        child: Lottie.asset(
          'assets/plant_main_page.json',
          controller: _controller,
          fit: BoxFit.fitWidth,
          onLoaded: (composition) {
            _controller.duration = composition.duration;
            _controller.forward(); // ilk başta ileri oynasın
          },
        ),
      ),
    );
  }
}
