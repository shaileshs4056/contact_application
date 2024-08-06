// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:contact_number_demo/generated/l10n.dart';

import '../../router/app_router.dart';
import '../db/app_db.dart';

class DioExceptionUtil {
  // general methods:------------------------------------------------------------
  static String handleError(DioException error) {
    String errorDescription = S.current.unknownError;

    debugPrint(error.toString());
    switch (error.type) {
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          errorDescription =
              S.current.connectionToServerFailedDueToInternetConnection;
        } else if (error.response!.statusCode == -9) {
          errorDescription = S.current.noActiveInternetConnection;
        } else {
          errorDescription = S.current.somethingWentWrongPleaseTryAfterSometime;
        }
        break;
      case DioExceptionType.cancel:
        errorDescription = S.current.requestToServerWasCancelled;
        break;
      case DioExceptionType.connectionTimeout:
        errorDescription = S.current.connectionTimeoutWithServer;
        break;
      case DioExceptionType.receiveTimeout:
        errorDescription =
            S.current.requestCantBeHandledForNowPleaseTryAfterSometime;
        break;

      case DioExceptionType.badResponse:
        debugPrint("Response:");
        debugPrint(error.toString());
        if (error.response!.statusCode == 12039 ||
            error.response!.statusCode == 12040) {
          errorDescription =
              S.current.connectionToServerFailedDueToInternetConnection;
        } else if (401 == error.response!.statusCode) {
          errorDescription = S.current.pleaseLoginAgain;
          appDB.logout();
          // appRouter.replaceAll([const LoginRoute()]);
        } else if (401 < error.response!.statusCode! &&
            error.response!.statusCode! <= 417) {
          errorDescription = S.current.somethingWhenWrongPleaseTryAgain;
        } else if (500 <= error.response!.statusCode! &&
            error.response!.statusCode! <= 505) {
          errorDescription =
              S.current.requestCantBeHandledForNowPleaseTryAfterSometime;
        } else {
          errorDescription = S.current.somethingWentWrongPleaseTryAfterSometime;
        }
        break;
      case DioExceptionType.sendTimeout:
        errorDescription =
            S.current.requestCantBeHandledForNowPleaseTryAfterSometime;
        break;
      case DioExceptionType.badCertificate:
        errorDescription =
            S.current.requestCantBeHandledForNowPleaseTryAfterSometime;
        break;
      case DioExceptionType.connectionError:
        errorDescription = S.current.connectionTimeoutWithServer;
        break;
    }
    return errorDescription;
  }
}
