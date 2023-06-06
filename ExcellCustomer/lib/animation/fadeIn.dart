import 'package:ExcellCustomer/models/enum.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
// import 'package:supercharged/supercharged.dart';

class FadeIn extends StatelessWidget {
  final double? delay;
  final Widget? child;
  final bool translate;
  final double distance;
  final double? duration;
  final Direction? direction;

  FadeIn(this.child, this.delay,
      {this.direction,
      this.translate = true,
      this.duration = 1,
      this.distance = 130.0});

  @override
  Widget build(BuildContext context) {
    if (direction == Direction.y) {
      final tween = MultiTween<_AniProps>()
        ..add(_AniProps.opacity, Tween(begin: 0.0, end: 1.0))
        ..add(_AniProps.translateY, Tween(begin: distance, end: 0.0));

      return PlayAnimation<MultiTweenValues<_AniProps>>(
        delay: Duration(milliseconds: (300.0 * delay!).round()),
        duration: Duration(milliseconds: (300.0 * duration!).round()),
        tween: tween,
        child: child,
        builder: (context, child, value) => Opacity(
          opacity: value.get(_AniProps.opacity),
          child: translate
              ? Transform.translate(
                  offset: Offset(0, value.get(_AniProps.translateY)),
                  child: child,
                )
              : child,
        ),
      );
    } else {
      final tween = MultiTween<_AniProps>()
        ..add(_AniProps.opacity, Tween(begin: 0.0, end: 1.0))
        ..add(_AniProps.translateX, Tween(begin: distance, end: 1.0));

      return PlayAnimation<MultiTweenValues<_AniProps>>(
        delay: Duration(milliseconds: (300 * delay!).round()),
        duration: Duration(milliseconds: (300 * duration!).round()),
        tween: tween,
        child: child,
        builder: (context, child, value) => Opacity(
          opacity: value.get(_AniProps.opacity),
          child: translate
              ? Transform.translate(
                  offset: Offset(value.get(_AniProps.translateX), 0),
                  child: child,
                )
              : child,
        ),
      );
    }
  }
}

enum _AniProps { opacity, translateY, translateX }
