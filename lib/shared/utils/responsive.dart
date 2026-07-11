import 'package:flutter/material.dart';

/// Design reference size (iPhone 11 / common mobile baseline).
const Size kDesignSize = Size(375, 812);

/// Call once from [MaterialApp.builder] (or any root widget) so
/// [num] extensions like `.w`, `.h`, `.sp` work app-wide.
class Responsive {
  Responsive._();

  static late MediaQueryData _mediaQuery;
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _scaleWidth;
  static late double _scaleHeight;
  static late double _textScale;
  static late double _pixelRatio;
  static late Orientation _orientation;
  static bool _initialized = false;

  static void init(
    BuildContext context, {
    Size designSize = kDesignSize,
  }) {
    _mediaQuery = MediaQuery.of(context);
    _screenWidth = _mediaQuery.size.width;
    _screenHeight = _mediaQuery.size.height;
    _pixelRatio = _mediaQuery.devicePixelRatio;
    _orientation = _mediaQuery.orientation;
    _scaleWidth = _screenWidth / designSize.width;
    _scaleHeight = _screenHeight / designSize.height;
    _textScale = _scaleWidth.clamp(0.85, 1.35);
    _initialized = true;
  }

  static bool get isInitialized => _initialized;

  static MediaQueryData get mediaQuery {
    _ensureInit();
    return _mediaQuery;
  }

  static double get screenWidth {
    _ensureInit();
    return _screenWidth;
  }

  static double get screenHeight {
    _ensureInit();
    return _screenHeight;
  }

  static double get pixelRatio {
    _ensureInit();
    return _pixelRatio;
  }

  static Orientation get orientation {
    _ensureInit();
    return _orientation;
  }

  static double get scaleWidth {
    _ensureInit();
    return _scaleWidth;
  }

  static double get scaleHeight {
    _ensureInit();
    return _scaleHeight;
  }

  /// Shortest side — useful for phone vs tablet checks.
  static double get shortestSide {
    _ensureInit();
    return _mediaQuery.size.shortestSide;
  }

  static bool get isMobile => shortestSide < 600;
  static bool get isTablet => shortestSide >= 600 && shortestSide < 1024;
  static bool get isDesktop => shortestSide >= 1024;
  static bool get isPortrait => orientation == Orientation.portrait;
  static bool get isLandscape => orientation == Orientation.landscape;

  /// Scale by width (padding, widths, horizontal spacing).
  static double w(double size) {
    _ensureInit();
    return size * _scaleWidth;
  }

  /// Scale by height (heights, vertical spacing).
  static double h(double size) {
    _ensureInit();
    return size * _scaleHeight;
  }

  /// Scale font size (clamped so text doesn't explode on tablets).
  static double sp(double size) {
    _ensureInit();
    return size * _textScale;
  }

  /// Scale by the smaller of width/height (radius, icons, squares).
  static double r(double size) {
    _ensureInit();
    return size * (_scaleWidth < _scaleHeight ? _scaleWidth : _scaleHeight);
  }

  /// Percentage of screen width (0–100).
  static double wp(double percent) {
    _ensureInit();
    return _screenWidth * (percent / 100);
  }

  /// Percentage of screen height (0–100).
  static double hp(double percent) {
    _ensureInit();
    return _screenHeight * (percent / 100);
  }

  static EdgeInsets get viewPadding {
    _ensureInit();
    return _mediaQuery.viewPadding;
  }

  static EdgeInsets get viewInsets {
    _ensureInit();
    return _mediaQuery.viewInsets;
  }

  static double get statusBarHeight => viewPadding.top;
  static double get bottomSafeArea => viewPadding.bottom;

  static void _ensureInit() {
    assert(
      _initialized,
      'Responsive.init(context) was not called. '
      'Wrap MaterialApp with builder that calls Responsive.init(context).',
    );
  }
}

/// Shorthand extensions: `16.w`, `24.h`, `14.sp`, `12.r`
extension ResponsiveNum on num {
  double get w => Responsive.w(toDouble());
  double get h => Responsive.h(toDouble());
  double get sp => Responsive.sp(toDouble());
  double get r => Responsive.r(toDouble());
  double get wp => Responsive.wp(toDouble());
  double get hp => Responsive.hp(toDouble());
}

/// Context helpers without relying on [Responsive.init].
extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  double get shortestSide => screenSize.shortestSide;
  Orientation get orientation => MediaQuery.orientationOf(this);

  bool get isMobile => shortestSide < 600;
  bool get isTablet => shortestSide >= 600 && shortestSide < 1024;
  bool get isDesktop => shortestSide >= 1024;

  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
}
