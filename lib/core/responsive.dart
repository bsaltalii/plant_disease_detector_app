import 'package:flutter/material.dart';

class R {
  static bool isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;
  static EdgeInsets padding(BuildContext c) =>
      isTablet(c) ? const EdgeInsets.symmetric(horizontal: 48, vertical: 24)
          : const EdgeInsets.symmetric(horizontal: 24, vertical: 16);

  static double titleSize(BuildContext c) => isTablet(c) ? 40 : 34;
  static double maxFormWidth(BuildContext c) => isTablet(c) ? 520 : 460;
}
