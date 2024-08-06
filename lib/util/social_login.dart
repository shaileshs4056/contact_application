import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:contact_number_demo/data/model/response/user_profile_response.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:uuid/uuid.dart';

class SocialLogin {
  /// call login method
  /// var repos = await SocialLogin.loginWithTwitter();
  // debugPrint(repos.errorMessage);
  Future<AuthResult> loginWithTwitter() async {
    final twitterLogin = TwitterLogin(
      // Consumer API keys
      apiKey: 'xxxx',
      // Consumer API Secret keys
      apiSecretKey: 'xxxx',
      // Registered Callback URLs in TwitterApp
      // Android is a deeplink
      // iOS is a URLScheme
      redirectURI: 'example://',
    );

    final AuthResult authResult = await twitterLogin.login();

    switch (authResult.status!) {
      case TwitterLoginStatus.loggedIn:
        // signup with rest API
        break;
      case TwitterLoginStatus.cancelledByUser:
        // show cancel message
        break;
      case TwitterLoginStatus.error:
        // show error message
        break;
    }
    return authResult;
  }

  Future<User?> loginWithGoogle() async {
    await Firebase.initializeApp();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
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
          await auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);

        final User? currentUser = auth.currentUser;
        assert(user.uid == currentUser!.uid);

        debugPrint('signInWithGoogle succeeded: $user');
        await googleSignIn.signOut();

        return user;
      } else {
        return null;
      }
    } catch (error) {
      debugPrint("G-SignIn error: $error");
      return null;
    }
  }

  //AuthorizationAppleID(null, Hemang, Vyas, hemangv@hyperlinkinfosystem.net.in, authorizationCode set? true, 40615467-3bc3-46bb-ba47-ed3f32a03eb8)

  Future<UserData?> loginInWithApple() async {
    //https://www.youtube.com/watch?v=VzRWh5QB3U8

    final bool isAvailable = await SignInWithApple.isAvailable();

    debugPrint("Apple Login available..? $isAvailable");
    final clientState = const Uuid().v4();
    if (isAvailable) {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.hyperlink.contact_number_demo',
          redirectUri: Uri.parse(
            'https://first-ossified-foe.glitch.me/callbacks/sign_in_with_apple',
          ),
        ),
        // TODO: Remove these if you have no need for them
        //nonce: 'example-nonce',
        state: clientState,
      );

      debugPrint(credential.toString());
      debugPrint("userIdentifier    ${credential.userIdentifier}");
      debugPrint("givenName         ${credential.givenName}");
      debugPrint("familyName        ${credential.familyName}");
      debugPrint("email             ${credential.email}");
      debugPrint("authorizationCode ${credential.authorizationCode}");
      debugPrint("identityToken     ${credential.identityToken}");
      debugPrint("state             ${credential.state}");

      if (credential.identityToken != null) {
        final result = parseJwt(credential.identityToken!);
        return UserData(
          id: result["sub"] as int?,
          email: result["email"] as String?,
        );
      } else {
        return null;
      }
    } else {
      final url = Uri.https('appleid.apple.com', '/auth/authorize', {
        'response_type': 'code id_token',
        'client_id': 'com.hyperlink.contact_number_demo',
        'response_mode': 'form_post',
        'redirect_uri':
            'https://first-ossified-foe.glitch.me/callbacks/sign_in_with_apple',
        'scope': 'email name',
        'state': clientState,
      });

      final result = await FlutterWebAuth.authenticate(
        url: url.toString(),
        callbackUrlScheme: "applink",
      );

      final body = Uri.parse(result).queryParameters;
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: body['id_token'],
        accessToken: body['code'],
      );

      final data =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      debugPrint(data.toString());

      return null;
    }
  }

/*  {
  "iss": "https://appleid.apple.com",
  "aud": "com.hyperlink.contact_number_demo",
  "exp": 1614276639,
  "iat": 1614190239,
  "sub": "001966.c1ca87aaabca44368dd8c4fe15cd645f.0745",
  "c_hash": "hmfJGMXW68atYahgs8OKvw",
  "email": "12hemang@gmail.com",
  "email_verified": "true",
  "auth_time": 1614190239,
  "nonce_supported": true
  }*/
  static Map<String, dynamic> parseJwt(String token) {
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

  //idkwwlmytn_1612935408@tfbnw.net
  //FbTest123

  static Future<UserData?> loginWithFacebook() async {
    // loginBehavior is only supported for Android devices, for ios it will be ignored
    final result = await FacebookAuth.instance
        .login(permissions: ['email'], loginBehavior: LoginBehavior.webOnly);

    if (result.status == LoginStatus.success) {
      debugPrint(result.accessToken.toString());

      // get the user data
      // by default we get the userId, email,name and picture
      // final userData = await FacebookAuth.instance.getUserData();
      final userData = await FacebookAuth.instance
          .getUserData(fields: "email,birthday,friends,gender,link");
      return UserData.fromJson(userData);
    } else if (result.status == LoginStatus.cancelled) {
      // user cancel login
      return null;
    } else if (result.status == LoginStatus.failed) {
      // login failed
      return null;
    } else {
      debugPrint(result.status.toString());
      debugPrint(result.message);
    }
    return null;
  }
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
