library keicy_firebase_authentication;

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class KeicyAuthentication {
  static KeicyAuthentication _instance = KeicyAuthentication();
  static KeicyAuthentication get instance => _instance;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final RegExp regExp = RegExp(r'(PlatformException\()|(FirebaseError)|([(:,.)])');

  Future<Map<String, dynamic>> signIn({@required String email, @required String password}) async {
    try {
      FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
      return {"state": true, "user": user};
    } on PlatformException catch (e) {
      return {"state": false, "errorCode": e.code, "errorString": e.message};
    } catch (e) {
      List<String> list = e.toString().split(regExp);

      String errorString = list[2];
      String errorCode;
      if (e.toString().contains("FirebaseError")) {
        errorCode = list[4];
      } else {
        errorCode = list[2];
      }

      ///   --- Error Codes ---
      /// ERROR_USER_NOT_FOUND, ERROR_WRONG_PASSWORD,ERROR_NETWORK_REQUEST_FAILED
      ///
      return {"state": false, "errorCode": errorCode, "errorString": errorString};
    }
  }

  Future<Map<String, dynamic>> signUp({@required String email, @required String password}) async {
    try {
      FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
      return {"state": true, "user": user};
    } on PlatformException catch (e) {
      return {"state": false, "errorCode": e.code, "errorString": e.message};
    } catch (e) {
      List<String> list = e.toString().split(regExp);

      String errorString = list[2];
      String errorCode;
      if (e.toString().contains("FirebaseError")) {
        errorCode = list[4];
      } else {
        errorCode = list[2];
      }

      ///   --- Error Codes ---
      /// ERROR_USER_NOT_FOUND, ERROR_WRONG_PASSWORD,ERROR_NETWORK_REQUEST_FAILED
      ///
      return {"state": false, "errorCode": errorCode, "errorString": errorString};
    }
  }

  Future<Map<String, dynamic>> anonySignIn() async {
    try {
      FirebaseUser user = (await _firebaseAuth.signInAnonymously()).user;
      return {"state": true, "user": user};
    } on PlatformException catch (e) {
      return {"state": false, "errorCode": e.code, "errorString": e.message};
    } catch (e) {
      List<String> list = e.toString().split(regExp);

      String errorString = list[2];
      String errorCode;
      if (e.toString().contains("FirebaseError")) {
        errorCode = list[4];
      } else {
        errorCode = list[2];
      }

      ///   --- Error Codes ---
      /// ERROR_USER_NOT_FOUND, ERROR_WRONG_PASSWORD,ERROR_NETWORK_REQUEST_FAILED
      ///
      return {"state": false, "errorCode": errorCode, "errorString": errorString};
    }
  }

  Future<Map<String, dynamic>> googleSignIn() async {
    try {
      final GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential _credential = GoogleAuthProvider.getCredential(
        accessToken: _googleAuth.accessToken,
        idToken: _googleAuth.idToken,
      );
      FirebaseUser user = (await _firebaseAuth.signInWithCredential(_credential)).user;
      return {"state": true, "user": user};
    } on PlatformException catch (e) {
      return {"state": false, "errorCode": e.code, "errorString": e.message};
    } catch (e) {
      List<String> list = e.toString().split(regExp);

      String errorString = list[2];
      String errorCode;
      if (e.toString().contains("FirebaseError")) {
        errorCode = list[4];
      } else {
        errorCode = list[2];
      }

      ///   --- Error Codes ---
      /// ERROR_USER_NOT_FOUND, ERROR_WRONG_PASSWORD,ERROR_NETWORK_REQUEST_FAILED
      ///
      return {"state": false, "errorCode": errorCode, "errorString": errorString};
    }
  }

  // Future<Map<String, dynamic>> facebookSignIn() async {
  //   try {
  //     FacebookLogin facebookLogin = FacebookLogin();
  //     facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
  //     FacebookLoginResult result = await facebookLogin.logIn(['email']);
  //     switch (result.status) {
  //       case FacebookLoginStatus.loggedIn:
  //         AuthCredential authCredential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);
  //         FirebaseUser user = (await _firebaseAuth.signInWithCredential(authCredential)).user;
  //         return {"state": true, "user": user};
  //         break;
  //       case FacebookLoginStatus.cancelledByUser:
  //         return {"state": false, "errorCode": 1234, "errorString": result.errorMessage};
  //         break;
  //       case FacebookLoginStatus.error:
  //         return {"state": false, "errorCode": 1234, "errorString": result.errorMessage};
  //         break;
  //       default:
  //         return {"state": false, "errorCode": 1234, "errorString": "Facebook Sign Error"};
  //         break;
  //     }
  //   } on PlatformException catch (e) {
  //     return {"state": false, "errorCode": e.code, "errorString": e.message};
  //   } catch (e) {
  //     List<String> list = e.toString().split(regExp);

  //     String errorString = list[2];
  //     String errorCode;
  //     if (e.toString().contains("FirebaseError")) {
  //       errorCode = list[4];
  //     } else {
  //       errorCode = list[2];
  //     }

  //     ///   --- Error Codes ---
  //     /// ERROR_USER_NOT_FOUND, ERROR_WRONG_PASSWORD,ERROR_NETWORK_REQUEST_FAILED
  //     ///
  //     return {"state": false, "errorCode": errorCode, "errorString": errorString};
  //   }
  // }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<Map<String, dynamic>> resetPassword({String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return {"state": true};
    } on PlatformException catch (e) {
      return {"state": false, "errorCode": e.code, "errorString": e.message};
    } catch (e) {
      List<String> list = e.toString().split(regExp);

      String errorString = list[2];
      String errorCode;
      if (e.toString().contains("FirebaseError")) {
        errorCode = list[4];
      } else {
        errorCode = list[2];
      }

      ///   --- Error Codes ---
      /// ERROR_USER_NOT_FOUND, ERROR_WRONG_PASSWORD,ERROR_NETWORK_REQUEST_FAILED
      ///
      return {"state": false, "errorCode": errorCode, "errorString": errorString};
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      if (user.isEmailVerified == false) user.sendEmailVerification();
    } catch (e) {}
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Stream<FirebaseUser> currentUserStream() {
    return _firebaseAuth.onAuthStateChanged;
  }
}
