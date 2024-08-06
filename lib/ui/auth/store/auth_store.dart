import 'dart:convert';

import 'package:contact_number_demo/data/model/contact/contact.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:contact_number_demo/core/api/base_response/base_response.dart';
import 'package:contact_number_demo/core/exceptions/app_exceptions.dart';
import 'package:contact_number_demo/core/exceptions/dio_exception_util.dart';
import 'package:contact_number_demo/core/locator/locator.dart';
import 'package:contact_number_demo/data/model/request/login_request_model.dart';
import 'package:contact_number_demo/data/model/response/user_profile_response.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/repository_impl/auth_repo_impl.dart';
import '../../../core/api/base_response/fb_user_data.dart';
import '../../../core/db/app_db.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  @observable
  BaseResponse<UserData?>? loginResponse;

  @observable
  BaseResponse? logoutResponse;

  @observable
  String? errorMessage;

  @observable
  Set<ContactListModel> selectedFavorite = {};

  @observable
  Set<ContactListModel> selectedContacts = {};

  final GoogleSignIn googleSignIn = GoogleSignIn();

  _AuthStoreBase();

  @action
  bool isChecked(ContactListModel contact) {
    print('Current selectedContacts: $selectedContacts');
    if (selectedContacts.contains(contact)) {
      return selectedContacts.remove(contact);
    } else {
      return selectedContacts.add(contact);
    }
  }

  @action
  Future login(LoginRequestModel request) async {
    try {
      errorMessage = null;
      // var commonStoreFuture =
      //     ObservableFuture<BaseResponse<UserData?>>(authRepo.signIn(request));
      // loginResponse = await commonStoreFuture;
      await Future.delayed(const Duration(seconds: 5), () {});
      loginResponse = BaseResponse(message: "Login successfully", code: "1");
    } on DioException catch (dioError) {
      errorMessage = DioExceptionUtil.handleError(dioError);
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e, st) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);
      errorMessage = e.toString();
    }
  }

  @action
  Future logout() async {
    try {
      errorMessage = null;
      var commonStoreFuture = ObservableFuture<BaseResponse>(authRepo.logout());
      logoutResponse = await commonStoreFuture;
    } on DioException catch (dioError) {
      errorMessage = DioExceptionUtil.handleError(dioError);
    } on AppException catch (e) {
      errorMessage = e.toString();
    } catch (e, st) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);
      errorMessage = e.toString();
    }
  }

  Future<UserDataResponse?> signInWithApple() async {
    bool isAvailable = await SignInWithApple.isAvailable();
    debugPrint("Apple Login available..? $isAvailable");
    final clientState = Uuid().v4();
    if (isAvailable) {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
            clientId: 'com.whotry.android',
            redirectUri: Uri.parse(
              'https://first-ossified-foe.glitch.me/callbacks/sign_in_with_apple',
            )),
        state: clientState,
      );
      debugPrint("userIdentifier    ${credential.userIdentifier}");
      debugPrint("givenName         ${credential.givenName}");
      debugPrint("familyName        ${credential.familyName}");
      debugPrint("email             ${credential.email}");
      debugPrint("authorizationCode ${credential.authorizationCode}");
      debugPrint("identityToken     ${credential.identityToken}");
      debugPrint("state             ${credential.state}");
      if (credential.identityToken != null) {
        var result = parseJwt(credential.identityToken!);
        if (credential.givenName != null && credential.familyName != null) {
          await storage.write(
              key: "${result["sub"]}firstName", value: credential.givenName);
          await storage.write(
              key: "${result["sub"]}lastName", value: credential.familyName);
        }
        return UserDataResponse(
            sub: result["sub"],
            email: result["email"],
            firstName: credential.givenName,
            lastName: credential.familyName);
      } else {
        return null;
      }
    } else {
      final url = Uri.https('appleid.apple.com', '/auth/authorize', {
        'response_type': 'code id_token',
        'client_id': 'com.example.android',
        'response_mode': 'form_post',
        'redirect_uri':
            'https://first-ossified-foe.glitch.me/callbacks/sign_in_with_apple',
        'scope': 'email name',
        'state': clientState,
      });

      final result = await FlutterWebAuth.authenticate(
          url: url.toString(), callbackUrlScheme: "applink");

      final body = Uri.parse(result).queryParameters;
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: body['id_token'],
        accessToken: body['code'],
      );
      var data =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      return null;
    }
  }

  Future<UserData?> loginFb() async {
    final LoginResult result = await FacebookAuth.i.login(
        permissions: ["public_profile", "email"],
        loginBehavior: LoginBehavior
            .webOnly); // by default we request the email and the public profile
    switch (result.status) {
      case LoginStatus.success:
        final AccessToken accessToken = result.accessToken!;
        debugPrint('''
         Logged in!
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.grantedPermissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

        final userData = await FacebookAuth.instance.getUserData();
        debugPrint(userData.toString());
        FacebookAuth.instance.logOut();
        appDB.user = UserData(
            socialId: userData["id"],
            email: userData["email"],
            firstName: userData["name"],
            profileImage: userData["picture"]["data"]["url"]);
        return appDB.user;
      case LoginStatus.cancelled:
        debugPrint('Login cancelled by the user.');
        errorMessage = 'Login cancelled by the user';
        return null;
      case LoginStatus.failed:
        debugPrint('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.message}');
        errorMessage = 'Something went wrong';
        return null;
      case LoginStatus.operationInProgress:
        errorMessage = 'Something went wrong';
        return null;
    }
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    debugPrint("JsonDecode:--------------------");
    debugPrint(payload);
    debugPrint(jsonEncode(payloadMap));

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  Future<User?> signInWithGoogle() async {
    await Firebase.initializeApp();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return null;
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user!;

      if (user != null) {
        assert(!user.isAnonymous);

        final User currentUser = _auth.currentUser!;
        assert(user.uid == currentUser.uid);

        debugPrint('signInWithGoogle succeeded: $user');
        await googleSignIn.signOut();

        return user;
      } else {
        return null;
      }
    } catch (error) {
      debugPrint("G-SignIn error: $error");
      errorMessage = error.toString();
      return null;
    }
  }
}

final authStore = locator<AuthStore>();
final storage = new FlutterSecureStorage();
