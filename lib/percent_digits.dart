import 'package:flutter/material.dart';
import 'package:tickerissue/single_digit.dart';

class PercentDigits extends StatefulWidget {
  PercentDigits({required this.gain, required this.isLending});

  final String gain;
  final bool isLending;

  @override
  PercentDigitsState createState() => PercentDigitsState();
}

class PercentDigitsState extends State<PercentDigits>
    with
        AutomaticKeepAliveClientMixin {
  double digitHeight = 83.0;
  double decimalHeight = 33.0;
  double digitWidth = 34.0;
  double decimalWidth = 14.0;
  TextStyle? digitStyle;
  TextStyle? decimalStyle;

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
    digitStyle = TextStyle(
      fontSize: 20,
      fontFamily: Theme.of(context).textTheme.headline2?.fontFamily,
    );
    decimalStyle = TextStyle(
      fontSize: 20,
      fontFamily: Theme.of(context).textTheme.headline2?.fontFamily,
    );

    // check the digit sizes and fix if they are too small
    final Size realDigitSize = _getDigitSize(digitStyle);
    final Size realDecimalSize = _getDigitSize(decimalStyle);

    if (realDigitSize.width != digitWidth) {
      digitWidth = realDigitSize.width;
    }

    if (realDecimalSize.width != decimalWidth) {
      decimalWidth = realDecimalSize.width;
    }

    if (realDigitSize.height != digitHeight) {
      digitHeight = realDigitSize.height;
    }

    if (realDecimalSize.height != decimalHeight) {
      decimalHeight = realDecimalSize.height;
    }

    // calculate value to display
    bool isNegative = false;
    double inputValue = 0.0;
    final double gainDouble = double.tryParse(widget.gain) ?? 0.00;
    //double gainDouble = double.tryParse(viewModel.gain ?? '0.00') ?? 0.00;
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
          height: digitHeight,
          width: digitWidth,
          textStyle: digitStyle,
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
          textStyle: decimalStyle,
          height: decimalHeight,
          width: decimalWidth,
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
                    top: widget.isLending ? 0 : 12,
                    left: 12,
                  ),
                  child: decimals[0]),
              Padding(
                  padding: EdgeInsets.only(top: widget.isLending ? 0 : 12),
                  child: decimals[1]),
              Padding(
                padding:
                EdgeInsets.only(top: widget.isLending ? 0 : 10, left: 2),
                child: Text(
                  '%',
                  style: decimalStyle,
                ),
              ),
            ]),
          ]),
        ]);
  }

  @override
  bool get wantKeepAlive => true;
}
