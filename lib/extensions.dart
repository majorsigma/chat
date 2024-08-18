import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  Size get screenSize => MediaQuery.of(this).size;

  Future<T?> push<T extends Object?>(Route<T> route) {
    return Navigator.of(this).push(route);
  }

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  String restorablePopAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this).restorablePopAndPushNamed(routeName,
        result: result, arguments: arguments);
  }

  String restorablePushNamed<T extends Object?>(String routeName,
      {Object? arguments}) {
    return Navigator.of(this).restorablePushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this).popAndPushNamed(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  String restorablePushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this).restorablePushReplacementNamed(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  void pop<T extends Object?>([T? result]) {
    return Navigator.of(this).pop();
  }
}
