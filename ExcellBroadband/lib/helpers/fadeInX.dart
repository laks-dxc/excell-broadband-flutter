import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class FadeInX extends StatelessWidget {
  final double delay;
  final Widget child;
  final bool translate;
  final double duration;
  final double distance;

  FadeInX(this.delay, this.child,
      {this.translate: true, this.duration: 1, this.distance = 130.0});

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AniProps>()
      ..add(_AniProps.opacity, 0.0.tweenTo(1.0))
      ..add(_AniProps.translateX, distance.tweenTo(0.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: (300 * delay).round().milliseconds,
      duration: 500.milliseconds * duration,
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

enum _AniProps { opacity, translateX }
