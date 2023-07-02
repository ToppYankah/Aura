import 'package:aura/ui/screens/about_screen/about_screen.dart';
import 'package:aura/ui/screens/aqi_details_screen/aqi_details_screen.dart';
import 'package:aura/ui/screens/aqi_summary_screen/aqi_summary_screen.dart';
import 'package:aura/ui/screens/authentication/signin_screen.dart';
import 'package:aura/ui/screens/authentication/signup_screen.dart';
import 'package:aura/ui/screens/complete_profile_screen/complete_profile_screen.dart';
import 'package:aura/ui/screens/health_tips_screen/health_tips_screen.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:aura/ui/screens/issue_form_screen/report_issue_screen.dart';
import 'package:aura/ui/screens/map_screen/map_screen.dart';
import 'package:aura/ui/screens/readings_screen/readings_screen.dart';
import 'package:aura/ui/screens/choose_location_screen/choose_location_screen.dart';
import 'package:aura/ui/screens/request_location_screen/request_location_screen.dart';
import 'package:aura/ui/screens/onboarding_screen/onboarding_screen.dart';
import 'package:aura/ui/screens/splash_screen/splash_screen.dart';
import 'package:aura/ui/screens/web_view_screen/web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:aura/ui/screens/home_screen/home_screen.dart';
import 'package:aura/ui/global_components/slide_page_route.dart';

class NavigationParams<T> {
  final T? argument;
  final bool replace;

  const NavigationParams({this.argument, this.replace = false});
}

class ScreenRoutes {
  ScreenRoutes._();

  static const String home = '/';
  static const String about = '/about';
  static const String map = '/map_screen';
  static const String splash = '/splash_screen';
  static const String signIn = '/signin_screen';
  static const String signUp = '/signup_screen';
  static const String webView = '/web_view_screen';
  static const String reading = '/forecast_screen';
  static const String onboarding = '/onboarding_screen';
  static const String issueForm = '/report_issue_screen';
  static const String aqiDetails = '/aqi_details_screen';
  static const String aqiSummary = '/aqi_summary_screen';
  static const String healthTips = '/health_tips_screen';
  static const String chooseLocation = '/manual_location_screen';
  static const String completeProfile = '/complete_profile_screen';
  static const String requestLocation = '/request_location_screen';
}

class Navigation {
  Navigation._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String initialRoute = ScreenRoutes.splash;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ScreenRoutes.about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      case ScreenRoutes.aqiSummary:
        return MaterialPageRoute(builder: (_) => const AQISummaryScreen());
      case ScreenRoutes.aqiDetails:
        return MaterialPageRoute(builder: (_) => const AQIDetailsScreen());
      case ScreenRoutes.chooseLocation:
        return MaterialPageRoute(builder: (_) => const ChooseLocationScreen());
      case ScreenRoutes.completeProfile:
        return MaterialPageRoute(builder: (_) => const CompleteProfileScreen());
      case ScreenRoutes.healthTips:
        return MaterialPageRoute(builder: (_) => const HealthTipsScreen());
      case ScreenRoutes.home:
        return MaterialPageRoute(
            builder: (_) =>
                HomeScreen(page: settings.arguments as HomeScreenPage?));
      case ScreenRoutes.issueForm:
        return MaterialPageRoute(builder: (_) => const ReportIssueScreen());
      case ScreenRoutes.map:
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case ScreenRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case ScreenRoutes.requestLocation:
        return MaterialPageRoute(builder: (_) => const RequestLocationScreen());
      case ScreenRoutes.reading:
        return MaterialPageRoute(builder: (_) => const ReadingsScreen());
      case ScreenRoutes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case ScreenRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case ScreenRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case ScreenRoutes.webView:
        return MaterialPageRoute(
            builder: (_) => WebViewScreen(url: settings.arguments as String));
      default:
        return SlidePageRoute(child: const SplashScreen());
    }
  }

  static openMap(BuildContext context, [NavigationParams<String>? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(context, ScreenRoutes.map,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.map,
        arguments: params?.argument);
  }

  static openAbout(BuildContext context, [NavigationParams<String>? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(context, ScreenRoutes.about,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.about,
        arguments: params?.argument);
  }

  static openCompleteProfile(BuildContext context,
      [NavigationParams<String>? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(
          context, ScreenRoutes.completeProfile,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.completeProfile,
        arguments: params?.argument);
  }

  static openWebView(BuildContext context, [NavigationParams<String>? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(context, ScreenRoutes.webView,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.webView,
        arguments: params?.argument);
  }

  static openHealthTipsScreen(BuildContext context,
      [NavigationParams? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(context, ScreenRoutes.healthTips,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.healthTips,
        arguments: params?.argument);
  }

  static openAQIDetailsScreen(BuildContext context,
      [NavigationParams? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(context, ScreenRoutes.aqiDetails,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.aqiDetails,
        arguments: params?.argument);
  }

  static openAQISummaryScreen(BuildContext context,
      [NavigationParams? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(context, ScreenRoutes.aqiSummary,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.aqiSummary,
        arguments: params?.argument);
  }

  static openForecastScreen(BuildContext context, [NavigationParams? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(context, ScreenRoutes.reading,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.reading,
        arguments: params?.argument);
  }

  static openHomeScreen(BuildContext context, [NavigationParams? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(context, ScreenRoutes.home,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.home,
        arguments: params?.argument);
  }

  static openSignInScreen(BuildContext context, [NavigationParams? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(context, ScreenRoutes.signIn,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.signIn,
        arguments: params?.argument);
  }

  static openSignUpScreen(BuildContext context, [NavigationParams? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(context, ScreenRoutes.signUp,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.signUp,
        arguments: params?.argument);
  }

  static openRequestLocationScreen(BuildContext context,
      [NavigationParams? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(
          context, ScreenRoutes.requestLocation,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.requestLocation,
        arguments: params?.argument);
  }

  static openManualLocationScreen(BuildContext context,
      [NavigationParams? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(
          context, ScreenRoutes.chooseLocation,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.chooseLocation,
        arguments: params?.argument);
  }

  static openOnboardingScreen(BuildContext context,
      [NavigationParams? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(context, ScreenRoutes.onboarding,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.onboarding,
        arguments: params?.argument);
  }

  static openMailForm(BuildContext context,
      [NavigationParams<String>? params]) {
    if (params?.replace ?? false) {
      return Navigator.pushReplacementNamed(context, ScreenRoutes.issueForm,
          arguments: params?.argument);
    }
    return Navigator.pushNamed(context, ScreenRoutes.issueForm,
        arguments: params?.argument);
  }

  static back({required BuildContext context}) {
    return Navigator.pop(context);
  }

  static openRoute({required Widget widget}) {
    return SlidePageRoute(child: widget);
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Page unavailable or not implemented"),
      ),
    );
  }
}
