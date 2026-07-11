import 'package:flutter/material.dart';
import 'package:movieapp/shared/utils/responsive.dart';

/// Initializes [Responsive] for the whole subtree.
/// Prefer using [MaterialApp.builder] once at the root.
class ResponsiveScope extends StatelessWidget {
  const ResponsiveScope({
    super.key,
    required this.child,
    this.designSize = kDesignSize,
  });

  final Widget child;
  final Size designSize;

  @override
  Widget build(BuildContext context) {
    Responsive.init(context, designSize: designSize);
    return child;
  }
}

/// Picks a layout by breakpoint (mobile / tablet / desktop).
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).shortestSide;

    if (width >= 1024 && desktop != null) {
      return desktop!(context);
    }
    if (width >= 600 && tablet != null) {
      return tablet!(context);
    }
    return mobile(context);
  }
}

/// Returns a value based on the current breakpoint.
class ResponsiveValue<T> {
  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final T mobile;
  final T? tablet;
  final T? desktop;

  T resolve(BuildContext context) {
    final width = MediaQuery.sizeOf(context).shortestSide;
    if (width >= 1024 && desktop != null) return desktop as T;
    if (width >= 600 && tablet != null) return tablet as T;
    return mobile;
  }
}

/// Constrains content width on large screens (centered).
class ResponsiveConstrained extends StatelessWidget {
  const ResponsiveConstrained({
    super.key,
    required this.child,
    this.maxWidth = 600,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding == null ? child : Padding(padding: padding!, child: child),
      ),
    );
  }
}
