import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// A customizable stepper widget inspired by
/// [Nikolay Kuchkarov](https://dribbble.com/shots/3368130-Stepper-Touch).
/// This widget extends the original concept by adding functionality
/// that makes it more useful for real-world applications.
class StepperTouch extends StatefulWidget {
  /// Creates a `StepperTouch` widget.
  ///
  /// The [initialValue] and [onChanged] parameters are required.
  /// The [direction] parameter defaults to [Axis.horizontal].
  /// The [withSpring] parameter defaults to `true`.
  const StepperTouch({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.direction = Axis.horizontal,
    this.withSpring = true,
    this.counterColor = const Color(0xFF6D72FF),
    this.dragButtonColor = Colors.white,
    this.buttonsColor = Colors.white,
  });

  /// The orientation of the stepper, either horizontal or vertical.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis direction;

  /// The initial value of the stepper.
  final int initialValue;

  /// A callback that is triggered when the value of the stepper changes.
  ///
  /// The callback receives the new value as an argument.
  final ValueChanged<int> onChanged;

  /// Whether a spring simulation should occur when the user releases the stepper.
  ///
  /// Defaults to `true`.
  final bool withSpring;

  /// The color of the counter.
  ///
  /// Defaults to `Color(0xFF6D72FF)`.
  final Color counterColor;

  /// The color of the draggable button.
  ///
  /// Defaults to `Colors.white`.
  final Color dragButtonColor;

  /// The color of the buttons.
  ///
  /// Defaults to `Colors.white`.
  final Color buttonsColor;

  @override
  _Stepper2State createState() => _Stepper2State();
}

class _Stepper2State extends State<StepperTouch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late int _value;
  late double _startAnimationPosX;
  late double _startAnimationPosY;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _controller = AnimationController(
      vsync: this,
      lowerBound: -0.5,
      upperBound: 0.5,
    );
    _controller.value = 0.0;
    _controller.addListener(() {});

    if (widget.direction == Axis.horizontal) {
      _animation =
          Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.5, 0.0)).animate(
        _controller,
      );
    } else {
      _animation =
          Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.5)).animate(
        _controller,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.direction == Axis.horizontal) {
      _animation = Tween<Offset>(
        begin: Offset(0.0, 0.0),
        end: Offset(1.5, 0.0),
      ).animate(_controller);
    } else {
      _animation = Tween<Offset>(
        begin: Offset(0.0, 0.0),
        end: Offset(0.0, 1.5),
      ).animate(_controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        width: widget.direction == Axis.horizontal ? 280.0 : 120.0,
        height: widget.direction == Axis.horizontal ? 120.0 : 280.0,
        child: Material(
          type: MaterialType.canvas,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(60.0),
          color: Colors.white.withOpacity(0.2),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildMinusIcon(),
              _buildPlusIcon(),
              _buildValueIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueIndicator() {
    return GestureDetector(
      onHorizontalDragStart: _onPanStart,
      onHorizontalDragUpdate: _onPanUpdate,
      onHorizontalDragEnd: _onPanEnd,
      child: SlideTransition(
        position: _animation,
        child: Material(
          color: widget.dragButtonColor,
          shape: const CircleBorder(),
          elevation: 5.0,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  child: child,
                  scale: animation,
                );
              },
              child: Text(
                '$_value',
                key: ValueKey<int>(_value),
                style: TextStyle(
                  color: widget.counterColor,
                  fontSize: 56.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlusIcon() {
    return Positioned(
      right: widget.direction == Axis.horizontal ? 10.0 : null,
      top: widget.direction == Axis.horizontal ? null : 10.0,
      child: Icon(
        Icons.add,
        size: 40.0,
        color: widget.buttonsColor,
      ),
    );
  }

  Widget _buildMinusIcon() {
    return Positioned(
      left: widget.direction == Axis.horizontal ? 10.0 : null,
      bottom: widget.direction == Axis.horizontal ? null : 10.0,
      child: Icon(
        Icons.remove,
        size: 40.0,
        color: widget.buttonsColor,
      ),
    );
  }

  double offsetFromGlobalPos(Offset globalPosition) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset local = box.globalToLocal(globalPosition);
    _startAnimationPosX = ((local.dx * 0.75) / box.size.width) - 0.4;
    _startAnimationPosY = ((local.dy * 0.75) / box.size.height) - 0.4;
    if (widget.direction == Axis.horizontal) {
      return ((local.dx * 0.75) / box.size.width) - 0.4;
    } else {
      return ((local.dy * 0.75) / box.size.height) - 0.4;
    }
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    _controller.stop();
    bool isHor = widget.direction == Axis.horizontal;
    bool changed = false;
    if (_controller.value <= -0.20) {
      setState(() => isHor ? _value-- : _value++);
      changed = true;
    } else if (_controller.value >= 0.20) {
      setState(() => isHor ? _value++ : _value--);
      changed = true;
    }
    if (widget.withSpring) {
      final _kDefaultSpring = SpringDescription.withDampingRatio(
        mass: 0.9,
        stiffness: 250.0,
        ratio: 0.6,
      );
      if (widget.direction == Axis.horizontal) {
        _controller.animateWith(
          SpringSimulation(_kDefaultSpring, _startAnimationPosX, 0.0, 0.0),
        );
      } else {
        _controller.animateWith(
          SpringSimulation(_kDefaultSpring, _startAnimationPosY, 0.0, 0.0),
        );
      }
    } else {
      _controller.animateTo(0.0,
          curve: Curves.bounceOut, duration: Duration(milliseconds: 500));
    }

    if (changed) {
      widget.onChanged(_value);
    }
  }
}
