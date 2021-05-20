import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;
import 'package:pixell_app/localization/app_localizations.dart';

import 'my_constants.dart';
import 'my_utils.dart';

class MyRangeSliderData {
  double min;
  double max;
  double lowerValue;
  double upperValue;
  int divisions;
  bool showValueIndicator;
  int valueIndicatorMaxDecimals;
  bool forceValueIndicator;
  Color overlayColor;
  Color activeTrackColor;
  Color inactiveTrackColor;
  Color thumbColor;
  Color valueIndicatorColor;
  Color activeTickMarkColor;

  static const Color defaultActiveTrackColor = const Color(0xFF0175c2);
  static const Color defaultInactiveTrackColor = const Color(0x3d0175c2);
  static const Color defaultActiveTickMarkColor = const Color(0x8a0175c2);
  static const Color defaultThumbColor = const Color(0xFF0175c2);
  static const Color defaultValueIndicatorColor = const Color(0xFF0175c2);
  static const Color defaultOverlayColor = const Color(0x290175c2);

  MyRangeSliderData({
    this.min,
    this.max,
    this.lowerValue,
    this.upperValue,
    this.divisions,
    this.showValueIndicator: true,
    this.valueIndicatorMaxDecimals: 1,
    this.forceValueIndicator: false,
    this.overlayColor: defaultOverlayColor,
    this.activeTrackColor: defaultActiveTrackColor,
    this.inactiveTrackColor: defaultInactiveTrackColor,
    this.thumbColor: defaultThumbColor,
    this.valueIndicatorColor: defaultValueIndicatorColor,
    this.activeTickMarkColor: defaultActiveTickMarkColor,
  });

  // Returns the values in text format, with the number
  // of decimals, limited to the valueIndicatedMaxDecimals
  //
  String get lowerValueText =>
      lowerValue.toStringAsFixed(valueIndicatorMaxDecimals);

  String get upperValueText =>
      upperValue.toStringAsFixed(valueIndicatorMaxDecimals);

  // Builds a RangeSlider and customizes the theme
  // based on parameters
  //
  Widget build(BuildContext context, frs.RangeSliderCallback callback) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text(lowerValueText),
              ),
              Expanded(
                child: SliderTheme(
                  // Customization of the SliderTheme
                  // based on individual definitions
                  // (see rangeSliders in _RangeSliderSampleState)
                  data: SliderTheme.of(context).copyWith(
                    overlayColor: overlayColor,
                    activeTickMarkColor: activeTickMarkColor,
                    activeTrackColor: activeTrackColor,
                    inactiveTrackColor: inactiveTrackColor,
                    //trackHeight: 8.0,
                    thumbColor: thumbColor,
                    valueIndicatorColor: valueIndicatorColor,
                    showValueIndicator: showValueIndicator
                        ? ShowValueIndicator.always
                        : ShowValueIndicator.onlyForDiscrete,
                  ),
                  child: frs.RangeSlider(
                    min: min,
                    max: max,
                    lowerValue: lowerValue,
                    upperValue: upperValue,
                    divisions: divisions,
                    showValueIndicator: showValueIndicator,
                    valueIndicatorMaxDecimals: valueIndicatorMaxDecimals,
                    onChanged: (double lower, double upper) {
                      // call
                      callback(lower, upper);
                    },
                  ),
                ),
              ),
              Container(
                child: Text(upperValueText),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.fromLTRB(0.0, MyConstants.space_5, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).translate('label_from'),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: MyUtils().getColorFromHex(MyConstants.color_filter_header_value),
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).translate('label_to'),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: MyUtils().getColorFromHex(MyConstants.color_filter_header_value),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
