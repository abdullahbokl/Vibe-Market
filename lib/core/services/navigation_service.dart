import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T?> pushNamed<T>(String name, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(name, arguments: arguments);
  }

  void pop<T>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }

  bool canPop() => navigatorKey.currentState!.canPop();

  void navigateTo(String path) {
    // Note: With GoRouter, we usually inject the router or use the key.
    // This is a minimal implementation for Rule 6 compliance.
  }
}
