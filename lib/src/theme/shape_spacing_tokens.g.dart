// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:flutter/material.dart';
import 'dart:ui';

class BisonSpacingTokens extends ThemeExtension<BisonSpacingTokens> {
  final double noneSpacing;
  final double microSpacing;
  final double tinySpacing;
  final double smallSpacing;
  final double standardSpacing;
  final double mediumSpacing;
  final double largeSpacing;
  final double xLargeSpacing;

  const BisonSpacingTokens({
    required this.noneSpacing,
    required this.microSpacing,
    required this.tinySpacing,
    required this.smallSpacing,
    required this.standardSpacing,
    required this.mediumSpacing,
    required this.largeSpacing,
    required this.xLargeSpacing,
  });

  factory BisonSpacingTokens.standard() => const BisonSpacingTokens(
    noneSpacing: 0,
    microSpacing: 4,
    tinySpacing: 8,
    smallSpacing: 16,
    standardSpacing: 24,
    mediumSpacing: 36,
    largeSpacing: 48,
    xLargeSpacing: 64,
  );

  @override
  BisonSpacingTokens copyWith({
    double? noneSpacing,
    double? microSpacing,
    double? tinySpacing,
    double? smallSpacing,
    double? standardSpacing,
    double? mediumSpacing,
    double? largeSpacing,
    double? xLargeSpacing,
  }) {
    return BisonSpacingTokens(
      noneSpacing: noneSpacing ?? this.noneSpacing,
      microSpacing: microSpacing ?? this.microSpacing,
      tinySpacing: tinySpacing ?? this.tinySpacing,
      smallSpacing: smallSpacing ?? this.smallSpacing,
      standardSpacing: standardSpacing ?? this.standardSpacing,
      mediumSpacing: mediumSpacing ?? this.mediumSpacing,
      largeSpacing: largeSpacing ?? this.largeSpacing,
      xLargeSpacing: xLargeSpacing ?? this.xLargeSpacing,
    );
  }

  @override
  BisonSpacingTokens lerp(
    covariant ThemeExtension<BisonSpacingTokens>? other,
    double t,
  ) {
    if (other is! BisonSpacingTokens) return this;
    return BisonSpacingTokens(
      noneSpacing: lerpDouble(noneSpacing, other.noneSpacing, t)!,
      microSpacing: lerpDouble(microSpacing, other.microSpacing, t)!,
      tinySpacing: lerpDouble(tinySpacing, other.tinySpacing, t)!,
      smallSpacing: lerpDouble(smallSpacing, other.smallSpacing, t)!,
      standardSpacing: lerpDouble(standardSpacing, other.standardSpacing, t)!,
      mediumSpacing: lerpDouble(mediumSpacing, other.mediumSpacing, t)!,
      largeSpacing: lerpDouble(largeSpacing, other.largeSpacing, t)!,
      xLargeSpacing: lerpDouble(xLargeSpacing, other.xLargeSpacing, t)!,
    );
  }
}
