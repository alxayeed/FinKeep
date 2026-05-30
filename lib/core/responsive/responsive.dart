import 'package:flutter/material.dart';

/// ------------------------------------------
/// Responsive Utility
/// ------------------------------------------

/// A utility class for responsive and adaptive UI sizing based on
/// a Figma reference screen size. Provides methods to scale
/// width, height, radius, and font size.
class Responsive {
  Responsive._();

  /// Reference screen height from Figma design (passed dynamically)
  static late double referenceHeight;

  /// Reference screen width from Figma design (passed dynamically)
  static late double referenceWidth;

  /// Device screen height (initialized in [init])
  static late double screenHeight;

  /// Device screen width (initialized in [init])
  static late double screenWidth;

  /// Initializes the responsive system. Must be called once
  /// before using `.w`, `.h`, `.r`, `.hc()`, `.wc()`, or `.sp`.
  static void init(
    BuildContext context, {
    required double refHeight,
    required double refWidth,
  }) {
    referenceHeight = refHeight;
    referenceWidth = refWidth;

    final size = MediaQuery.sizeOf(context);
    screenHeight = size.height;
    screenWidth = size.width;
  }

  /// Returns true if the device is considered mobile (shortestSide < 600)
  static bool isMobile() => screenWidth < 600;

  /// Returns true if the device is considered tablet (shortestSide >= 600)
  static bool isTablet() => screenWidth >= 600;

  /// Clamps a height value between [min] and [max]
  static double clampHeight(double value, {double? min, double? max}) {
    return value.clamp(min ?? value, max ?? value);
  }

  /// Clamps a width value between [min] and [max]
  static double clampWidth(double value, {double? min, double? max}) {
    return value.clamp(min ?? value, max ?? value);
  }

  /// Clamps a font size between [min] and [max]
  static double clampFont(double value, {double? min, double? max}) {
    return value.clamp(min ?? value, max ?? value);
  }
}

/// ------------------------------------------
/// Extensions on `num` for clean responsive API
/// ------------------------------------------

extension ResponsiveSize on num {
  /// Scales a number relative to the device screen width.
  double get w {
    final scale = Responsive.screenWidth / Responsive.referenceWidth;
    if (Responsive.isMobile()) {
      final adjustedScale = scale < 1.0 ? (1.0 + (scale - 1.0) * 0.3) : scale;
      return this * adjustedScale;
    }
    return this * scale;
  }

  /// Scales a number relative to the device screen height.
  double get h {
    final scale = Responsive.screenHeight / Responsive.referenceHeight;
    if (Responsive.isMobile()) {
      final adjustedScale = scale < 1.0 ? (1.0 + (scale - 1.0) * 0.3) : scale;
      return this * adjustedScale;
    }
    return this * scale;
  }

  /// Scales a number relative to screen width for radius, square dimensions, or icon sizes.
  double get r {
    final scale = Responsive.screenWidth / Responsive.referenceWidth;
    if (Responsive.isMobile()) {
      final adjustedScale = scale < 1.0 ? (1.0 + (scale - 1.0) * 0.3) : scale;
      return this * adjustedScale;
    }
    return this * scale;
  }

  /// Scales height with optional min/max clamps for safe component sizing.
  double hc({double? min, double? max}) {
    final scaled = h;
    return Responsive.clampHeight(scaled, min: min, max: max);
  }

  /// Scales width with optional min/max clamps for safe component sizing.
  double wc({double? min, double? max}) {
    final scaled = w;
    return Responsive.clampWidth(scaled, min: min, max: max);
  }

  /// Responsive font size (scaled based on screen width)
  double get sp {
    final scale = Responsive.screenWidth / Responsive.referenceWidth;
    if (Responsive.isMobile()) {
      final adjustedScale = scale < 1.0 ? (1.0 + (scale - 1.0) * 0.2) : scale;
      return this * adjustedScale;
    }
    return this * scale;
  }

  /// Responsive font size with optional min/max clamp
  double fsc({double? min, double? max}) {
    final scaled = sp;
    return Responsive.clampFont(scaled, min: min, max: max);
  }
}
