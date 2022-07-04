import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_lunch_app/services/firestore_service.dart';
import 'package:group_lunch_app/shared/routes.dart';

import '../../services/authentication_service.dart';
import '../../services/locator.dart';
import '../../services/navigation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_notifier.dart';

class AuthNotifier extends BaseNotifier {
  final AuthenticationService _authService = locator<AuthenticationService>();
  final NavigationService _navService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  SharedPreferences? prefs;

  String? _verificationId;

  String? get verificationId => _verificationId;
  int? _resendToken;

  int? get resendToken => _resendToken;
  String? _phoneNumber;

  String? get phoneNumber => _phoneNumber;

  late AuthMode authMode;

  AuthNotifier(AuthMode authMode) {
    this.authMode = authMode;
  }

  Future signUp({
    required String password,
    required String phoneNumber,
  }) async {
    setBusy(true);
    var result = await _authService.signUpWithPhone(
      phoneNumber: phoneNumber,
      password: password,
      codeSent: (String verificationId, int? resendToken) async {
        prefs ??= await SharedPreferences.getInstance();
        prefs?.setString('verificationId', verificationId);
        prefs?.setString('phoneNumber', phoneNumber);
        if (resendToken != null) prefs?.setInt('resendToken', resendToken);
        print(
            'signup - verificationId: $verificationId | resendToken: $resendToken | phoneNumber: $phoneNumber');

        await fetchPrefs();

        setBusy(false);
        setAuthMode(AuthMode.verificationMode);
      },
    );
    if(result is UserCredential){
      if(result.user != null) _firestoreService.createUserData(result.user!);
      return result.user != null ? true : 'Sign Up Failed';
    }
    setBusy(false);
    if(result is FirebaseAuthException){
      if(result.code == 'email-already-in-use'){
        result = 'Phone Number already in use by another account.';
      }
    }
    return result.toString();
  }

  Future<bool> login({required String phoneNumber, required String password}) async {
    setBusy(true);
    //result is either bool or FirebaseAuthException
    var result =
        await _authService.login(phoneNumber: phoneNumber, password: password);
    setBusy(false);
    return result;
  }

  Future fetchPrefs() async {
    prefs ??= await SharedPreferences.getInstance();
    _verificationId = prefs?.getString('verificationId') ?? _verificationId;
    _resendToken = prefs?.getInt('resendToken') ?? _resendToken;
    _phoneNumber = prefs?.getString('phoneNumber') ?? _phoneNumber;
    print(
        'checkVId - verificationId: $_verificationId | resendToken: $_resendToken | phoneNumber: $_phoneNumber');
  }

  Future resendVerificationCode() async {
    print('resendVerificationCode called');
    if (phoneNumber == null) return false;
    print('phoneNumber not null');
    _authService.verifyPhoneNumber(
        phoneNumber: phoneNumber!,
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          print('new verificationId =  $verificationId');
          _verificationId = verificationId;
          _resendToken = resendToken;
        },
        resendToken: resendToken);
  }

  Future verifyCode(String smsCode) async {
    print("verify code called");
    setBusy(true);
    if (verificationId == null) return false;
    var result = await _authService.linkPhoneCredential(
        verificationId: verificationId!, smsCode: smsCode);
    setBusy(false);
    if (result is bool ) {
      return result;
    }
    if(result is FirebaseAuthException){
      if(result.code == 'invalid-verification-code'){
        return 'Invalid Verification Code';
      }
    }
    return 'Verification error';
  }

  Future navigateToHome() async {
    await _navService.navigateToAndReplaceAll(HomePageRoute);
  }

  setAuthMode(AuthMode newMode){
    authMode = newMode;
    notifyListeners();
  }
}

enum AuthMode { signUpMode, loginMode, verificationMode, welcomeMode }

extension Stringify on AuthMode {
  String toUppercaseString() {
    String val;
    switch (this) {
      case AuthMode.signUpMode:
        val = "SIGN UP";
        break;
      case AuthMode.loginMode:
        val = "LOGIN";
        break;
      case AuthMode.verificationMode:
        val = "VERIFY";
        break;
      case AuthMode.welcomeMode:
        val = "WELCOME";
        break;
    }
    return val;
  }
}
