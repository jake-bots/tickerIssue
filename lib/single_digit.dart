import 'dart:async';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SingleDigit extends StatefulWidget {
  SingleDigit({
    this.boxDecoration = const BoxDecoration(color: Colors.transparent),
    this.textStyle,
    this.initialValue = 0,
    this.height = 83,
    this.width = 34,
  });

  final TextStyle? textStyle;
  final BoxDecoration boxDecoration;
  final int initialValue;
  final double height;
  final double width;

  StreamController<int> valueController = StreamController<int>();

  @override
  State<StatefulWidget> createState() {
    final _SingleDigitState _state =
    _SingleDigitState(textStyle, boxDecoration, 0, initialValue);
    return _state;
  }
}

class _SingleDigitState extends State<SingleDigit>
    with TickerProviderStateMixin {
  _SingleDigitState(this._textStyle, this._boxDecoration, this._previousValue,
      this._currentValue);

  final TextStyle? _textStyle;
  final BoxDecoration _boxDecoration;

  int _previousValue = 0;
  int _currentValue = 0;

  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _initAnimation();

    widget.valueController.stream.listen(
          (int newValue) {
        _setValue(newValue);
      },
    );
  }

  void _initAnimation() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween<double>(
        begin: _previousValue.toDouble(), end: _currentValue.toDouble())
        .animate(_controller);

    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _controller.forward().orCancel;
  }

  @override
  void dispose() {
    widget.valueController.close();
    _controller.dispose();
    super.dispose();
  }

  void _setValue(int newValue) {
    _previousValue = _currentValue;
    _currentValue = newValue;

    _initAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final double verticalOffset = 0.0 - (_animation.value * widget.height);

    return Container(
      decoration: _boxDecoration,
      child: SizedOverflowBox(
        alignment: Alignment.topCenter,
        size: Size(widget.width, widget.height),
        child: ClipRect(
          clipper: CustomDigitClipper(Size(widget.width, widget.height)),
          child: Transform.translate(
            offset: Offset(0, verticalOffset),
            child: Column(
              children: <Widget>[
                for (int i = 0; i < 10; i++)
                  Container(
                    height: widget.height,
                    child: Text(
                      i.toString(),
                      style: _textStyle,
                      maxLines: 1,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDigitClipper extends CustomClipper<Rect> {
  CustomDigitClipper(this.digitSize);
  final Size digitSize;

  @override
  Rect getClip(Size size) =>
      Rect.fromPoints(Offset.zero, Offset(digitSize.width, digitSize.height));

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
