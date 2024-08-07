import 'dart:async';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:contact_number_demo/core/db/app_db.dart';
import 'package:contact_number_demo/core/locator/locator.dart';
import 'package:contact_number_demo/generated/l10n.dart';
import 'package:contact_number_demo/router/app_router.dart';
import 'package:contact_number_demo/values/export.dart';
import 'package:contact_number_demo/values/theme.dart';
import 'package:contact_number_demo/widget/custom_error_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await setupLocator();
      await locator.isReady<AppDB>();

      /// Disable debugPrint logs in production
      if (kReleaseMode) {
        debugPrint = (String? message, {int? wrapWidth}) {};
      }

      // initialize firebase app
      //await Firebase.initializeApp();

      // set error builder widget
      ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
        return CustomErrorWidget(errorDetails: errorDetails);
      };

      // Fixing App Orientation.
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]).then(
        (value) => runApp(MyApp(appRouter: locator<AppRouter>())),
      );
    },
    (error, stack) => (Object error, StackTrace stackTrace) {
      if (!kReleaseMode) {
        debugPrint('[Error]: $error');
        debugPrint('[Stacktrace]: $stackTrace');
      }
    },
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({required this.appRouter, super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      builder: (context, child) => MaterialApp.router(
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        builder: (BuildContext context, child) {
          child = ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
          child = MediaQuery(
            child: child,
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1.0), boldText: false),
          );
          return child;
        },
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),
        onGenerateTitle: (context) => S.of(context).applicationTitle,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
