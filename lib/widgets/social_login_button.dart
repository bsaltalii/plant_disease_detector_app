import 'package:flutter/material.dart';

class SocialLogoButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onPressed;
  final double size;

  const SocialLogoButton({
    super.key,
    required this.assetPath,
    required this.onPressed,
    this.size = 25,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
      ),
    );
  }
}
