import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/solana/presentation/solana_screen.dart';

class Routes {
  static const home = "/";
  static const solana = "solana";
  static String currentRoute = home;

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    currentRoute = routeSettings.name ?? "";

    if (kDebugMode) {
      print("Current route is $currentRoute");
    }

    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case solana:
        return SolanaScreen.route(routeSettings);
      default:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
    }
  }
}
