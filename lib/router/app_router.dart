import 'package:auto_route/auto_route.dart';
import 'package:contact_number_demo/core/locator/locator.dart';
import 'package:contact_number_demo/ui/auth/sign_up/sign_up_page.dart';
import 'package:contact_number_demo/ui/home/add_contact_number.dart';
import 'package:contact_number_demo/ui/home/delete_edit_page.dart';
import 'package:contact_number_demo/ui/home/show_contact_list.dart';
import 'package:contact_number_demo/ui/splash/splash_page.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
// extend the generated private router
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: AddContactNumberRoute.page),
    AutoRoute(page: ShowContactListRoute.page),
    AutoRoute(page: DeleteEditRoute.page),
  ];
}

final appRouter = locator<AppRouter>();
