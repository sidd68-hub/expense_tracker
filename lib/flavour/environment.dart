import 'package:expense_tracker/core/utils/app_enum.dart';

class Environment{
  static late Flavor flavor;

  static bool get isDev => flavor == Flavor.dev;
  static bool get isStage => flavor == Flavor.stage;
  static bool get isPreProd => flavor == Flavor.preProd;
  static bool get isProd => flavor == Flavor.prod;

  static String get baseUrl{
    switch (flavor){
      case Flavor.dev:
        return 'https://reqres.in/';
      case Flavor.stage:
        return 'https://reqres.in/';
      case Flavor.preProd:
        return 'https://reqres.in/';
      case Flavor.prod:
        return 'https://reqres.in/';
    }
  }
}