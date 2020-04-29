import 'package:flutter/material.dart';

import '../animator.dart';

class WidgetAnimator extends StatelessWidget {
  final Widget child;
  WidgetAnimator(this.child);
  @override
  Widget build(BuildContext context) {
    return Animator(child, wait());
  }
}