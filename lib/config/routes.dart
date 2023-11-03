import 'package:flutter/material.dart';
import 'package:new_project/module/home/add_menu_screen.dart';
import 'package:new_project/module/total/add_total_screen.dart';
import 'package:new_project/module/home/home.dart';
import 'package:new_project/module/home/splash_screen.dart';

class Routes {
  static const splashPage = '/';
  static const home = 'home';
  static const addTotalBalance = 'addTotalBalance';
  static const addMenuItem = 'addMenuItem';

  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    // final argument=settings.arguments;
    switch (settings.name) {
      case '/':
        return makeRoute(const SplashScreen(), settings);

      case 'home':
        return makeRoute(const HomeScreen(), settings);

      case 'addTotalBalance':
        return makeRoute(const AddTotalScreen(), settings);

      case 'addMenuItem':
        return makeRoute(const AddMenuScreen(), settings);
    }
    return null;
  }
}

Route? makeRoute(Widget widget, RouteSettings settings) {
  return MaterialPageRoute(
      builder: (context) {
        return widget;
      },
      settings: settings);
}

extension ContextExt on BuildContext {
  void back<T extends Object?>([T? result]) {
    return Navigator.of(this).pop();
  }

  Future<T?> left<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
        newRouteName, predicate,
        arguments: arguments);
  }

  Future<T?> toName<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }
}
