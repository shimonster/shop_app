import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomRouteToHome extends MaterialPageRoute {
  final route;
  final settings;

  CustomRouteToHome(this.route, this.settings)
      : super(builder: route, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final animationController = AnimationController(
      duration: Duration(milliseconds: 300),
    );
    final offsetAnimation = Tween<Offset>(
      begin: Offset(0, 1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.ease,
      ),
    );
    return AnimatedBuilder(
        animation: offsetAnimation,
        builder: (ctx, ch) {
          return child;
        });
  }
}

class CustomRouteToHomeTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    final offsetAnimation = Tween<Offset>(
      begin: Offset(0.5, 0),
      end: Offset(0, 0),
    ).animate(animation);
    if (route.canPop) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: offsetAnimation,
          child: child,
        ),
      );
    }
    final deviceSize = MediaQuery.of(context).size;
    final scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1,
    ).animate(animation);
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: child,
      ),
    );
  }
}
