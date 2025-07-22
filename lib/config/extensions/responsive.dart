import 'package:flutter/material.dart';

extension MediaQueryHelper on BuildContext {
  double get h => MediaQuery.sizeOf(this).height;
  double get w => MediaQuery.sizeOf(this).width;
}
