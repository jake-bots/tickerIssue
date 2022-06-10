import 'package:flutter/material.dart';
import 'package:tickerissue/single_digit.dart';

class PercentDigits extends StatefulWidget {
  PercentDigits({required this.gain});

  final String gain;

  @override
  PercentDigitsState createState() => PercentDigitsState();
}

class PercentDigitsState extends State<PercentDigits>
    with
        AutomaticKeepAliveClientMixin {

  // Digits of the investment amount
  List<SingleDigit?> digits = List<SingleDigit?>.filled(10, null);
  List<SingleDigit?> decimals = List<SingleDigit?>.filled(2, null);

  Size _getDigitSize(TextStyle? textStyle) {
    final TextPainter painter = TextPainter();
    painter.text = TextSpan(style: textStyle, text: '8');
    painter.textDirection = TextDirection.ltr;
    painter.textAlign = TextAlign.left;
    painter.textScaleFactor = 1.0;
    painter.layout();
    return painter.size;
  }

  @override
  Widget build(BuildContext context) {

    // calculate value to display
    bool isNegative = false;
    double inputValue = 0.0;
    final double gainDouble = double.tryParse(widget.gain) ?? 0.00;
    if (gainDouble < 0.0) {
      isNegative = true;
      inputValue = gainDouble.abs();
    } else {
      inputValue = gainDouble;
    }
    final String inputString = inputValue.toStringAsFixed(2);
    final List<String> values = inputString.split('.');
    final String beforeDecimal = values[0];
    final String afterDecimal = values[1];
    final int length = beforeDecimal.length;

    for (int i = 0; i < 10; i++) {
      if (i >= length) {
        digits[i] = null;
        break;
      }
      if (digits[i] == null) {
        digits[i] = SingleDigit(
          initialValue: int.tryParse(beforeDecimal[i]) ?? 0,
        );
      } else {
        digits[i]!.valueController.add(int.tryParse(beforeDecimal[i]) ?? 0);
      }
    }
    for (int j = 0; j < 2; j++) {
      if (decimals[j] == null) {
        decimals[j] = SingleDigit(
          initialValue: int.tryParse(afterDecimal[j]) ?? 0,
        );
      } else {
        decimals[j]!.valueController.add(int.tryParse(afterDecimal[j]) ?? 0);
      }
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: List<Widget>.generate(
                digits.length, (int i) => digits[i] ?? const SizedBox()),
          ),
          Stack(children: <Widget>[
            Row(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                    top: 12,
                    left: 12,
                  ),
                  child: decimals[0]),
              Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: decimals[1]),
            ]),
          ]),
        ]);
  }

  @override
  bool get wantKeepAlive => true;
}
