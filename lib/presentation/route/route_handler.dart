
import 'package:flutter/material.dart';
import 'package:themoviedex/presentation/route/route_link.dart';
import 'package:themoviedex/presentation/screen/splash/splash_page.dart';

PageRouteBuilder routeHandler(RouteSettings settings) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return createWidget(settings);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return createTransition(animation, child, settings.name);
    },
  );
}

SlideTransition createDefaultTransition(Animation<double> animation, Widget child) {
  return SlideTransition(
      position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
          .animate(animation), child: child,);
}

Widget createWidget(RouteSettings settings) {
  if (settings.name == RouteLink.splash) {
    SplashArgument argument = settings.arguments;
    return SplashPage(data: argument.data);
  }
  return null;
}

Widget createTransition(Animation<double> animation, Widget child, String routeLink) {
  if (routeLink == RouteLink.splash) {
    return createDefaultTransition(animation, child);
  }
  return createDefaultTransition(animation, child);
}


