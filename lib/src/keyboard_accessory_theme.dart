import 'package:flutter/material.dart';

@immutable
class KeyboardAccessoryTheme {
  const KeyboardAccessoryTheme({
    this.height = defaultHeight,
    this.blurSigma = 24.0,
    this.borderRadius,
    this.horizontalMargin = 8.0,
    this.horizontalPadding = 4.0,
    this.bottomGap = 4.0,
    this.lightGlassTint,
    this.darkGlassTint,
    this.lightBorderColor,
    this.darkBorderColor,
    this.lightHighlightColor,
    this.darkHighlightColor,
    this.lightIconColor,
    this.darkIconColor,
    this.disabledOpacity = 0.35,
    this.showHideDuration = const Duration(milliseconds: 150),
    this.showHideCurve = Curves.easeOut,
    this.fadeDuration = const Duration(milliseconds: 120),
  });

  static const double defaultHeight = 44.0;

  final double height;
  final double blurSigma;
  final BorderRadius? borderRadius;
  final double horizontalMargin;
  final double horizontalPadding;
  final double bottomGap;

  final Color? lightGlassTint;
  final Color? darkGlassTint;
  final Color? lightBorderColor;
  final Color? darkBorderColor;
  final Color? lightHighlightColor;
  final Color? darkHighlightColor;
  final Color? lightIconColor;
  final Color? darkIconColor;
  final double disabledOpacity;

  final Duration showHideDuration;
  final Curve showHideCurve;
  final Duration fadeDuration;

  KeyboardAccessoryTheme copyWith({
    double? height,
    double? blurSigma,
    BorderRadius? borderRadius,
    double? horizontalMargin,
    double? horizontalPadding,
    double? bottomGap,
    Color? lightGlassTint,
    Color? darkGlassTint,
    Color? lightBorderColor,
    Color? darkBorderColor,
    Color? lightHighlightColor,
    Color? darkHighlightColor,
    Color? lightIconColor,
    Color? darkIconColor,
    double? disabledOpacity,
    Duration? showHideDuration,
    Curve? showHideCurve,
    Duration? fadeDuration,
  }) {
    return KeyboardAccessoryTheme(
      height: height ?? this.height,
      blurSigma: blurSigma ?? this.blurSigma,
      borderRadius: borderRadius ?? this.borderRadius,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      bottomGap: bottomGap ?? this.bottomGap,
      lightGlassTint: lightGlassTint ?? this.lightGlassTint,
      darkGlassTint: darkGlassTint ?? this.darkGlassTint,
      lightBorderColor: lightBorderColor ?? this.lightBorderColor,
      darkBorderColor: darkBorderColor ?? this.darkBorderColor,
      lightHighlightColor: lightHighlightColor ?? this.lightHighlightColor,
      darkHighlightColor: darkHighlightColor ?? this.darkHighlightColor,
      lightIconColor: lightIconColor ?? this.lightIconColor,
      darkIconColor: darkIconColor ?? this.darkIconColor,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
      showHideDuration: showHideDuration ?? this.showHideDuration,
      showHideCurve: showHideCurve ?? this.showHideCurve,
      fadeDuration: fadeDuration ?? this.fadeDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KeyboardAccessoryTheme &&
        other.height == height &&
        other.blurSigma == blurSigma &&
        other.borderRadius == borderRadius &&
        other.horizontalMargin == horizontalMargin &&
        other.horizontalPadding == horizontalPadding &&
        other.bottomGap == bottomGap &&
        other.lightGlassTint == lightGlassTint &&
        other.darkGlassTint == darkGlassTint &&
        other.lightBorderColor == lightBorderColor &&
        other.darkBorderColor == darkBorderColor &&
        other.lightHighlightColor == lightHighlightColor &&
        other.darkHighlightColor == darkHighlightColor &&
        other.lightIconColor == lightIconColor &&
        other.darkIconColor == darkIconColor &&
        other.disabledOpacity == disabledOpacity &&
        other.showHideDuration == showHideDuration &&
        other.showHideCurve == showHideCurve &&
        other.fadeDuration == fadeDuration;
  }

  @override
  int get hashCode => Object.hash(
        height,
        blurSigma,
        borderRadius,
        horizontalMargin,
        horizontalPadding,
        bottomGap,
        lightGlassTint,
        darkGlassTint,
        lightBorderColor,
        darkBorderColor,
        lightHighlightColor,
        darkHighlightColor,
        lightIconColor,
        darkIconColor,
        disabledOpacity,
        showHideDuration,
        showHideCurve,
        fadeDuration,
      );
}
