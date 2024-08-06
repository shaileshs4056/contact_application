import 'dart:async';

import 'package:flutter/cupertino.dart';

enum SwipeDirection { vertical, horizontal }

class SlideFadeTransition extends StatefulWidget {
  ///The child on which to apply the given [SlideFadeTransition]
  final Widget child;

  ///The offset by which to slide and [child] into view from [Direction].
  ///Defaults to 0.2
  final double offset;

  ///The curve used to animate the [child] into view.
  ///Defaults to [Curves.easeIn]
  final Curve curve;

  ///The direction from which to animate the [child] into view. [Direction.horizontal]
  ///will make the child slide on x-axis by [offset] and [Direction.vertical] on y-axis.
  ///Defaults to [Direction.vertical]
  final SwipeDirection direction;

  final bool inverse;

  //final inverse = ValueNotifier<bool>(false);

  ///The delay with which to animate the [child]. Takes in a [Duration] and
  /// defaults to 0.0 seconds
  final Duration delayStart;

  ///The total duration in which the animation completes. Defaults to 800 milliseconds
  final Duration animationDuration;

  const SlideFadeTransition({
    required this.inverse,
    required this.child,
    this.offset = 0.2,
    this.curve = Curves.easeIn,
    this.direction = SwipeDirection.vertical,
    this.delayStart = Duration.zero,
    this.animationDuration = const Duration(milliseconds: 800),
    super.key,
  });

  @override
  State<SlideFadeTransition> createState() => _SlideFadeTransitionState();
}

class _SlideFadeTransitionState extends State<SlideFadeTransition>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> animationSlide;

  late AnimationController _animationController;

  late Animation<double> _animationFade;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _timer.cancel();
      }
    });

    //configure the animation controller as per the direction
    if (widget.direction == SwipeDirection.vertical) {
      animationSlide = Tween<Offset>(
        begin: Offset(
          0,
          widget.inverse ? -widget.offset : widget.offset,
        ),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          curve: widget.curve,
          parent: _animationController,
        ),
      );
    } else {
      animationSlide = Tween<Offset>(
        begin: Offset(
          widget.inverse ? -widget.offset : widget.offset,
          0,
        ),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          curve: widget.curve,
          parent: _animationController,
        ),
      );
    }

    _animationFade = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        curve: widget.curve,
        parent: _animationController,
      ),
    );

    _timer = Timer(widget.delayStart, () {
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationFade,
      child: SlideTransition(
        position: getAnimation(),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Animation<Offset> getAnimation() {
    return animationSlide = Tween<Offset>(
      begin: Offset(0, widget.inverse ? widget.offset : widget.offset),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        curve: widget.curve,
        parent: _animationController,
      ),
    );
  }
}
