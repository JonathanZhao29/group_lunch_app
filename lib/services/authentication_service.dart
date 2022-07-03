import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  User? get currentUser => _currentUser;

  Stream<User?> get authSubscription => _auth.authStateChanges();

  Future signUpWithPhone({required String phoneNumber, required String password,
    Function(PhoneAuthCredential)? verificationCompleted,
    Function(FirebaseAuthException)? verificationFailed,
    Function(String, int?)? codeSent,
    Function(String)? codeAutoRetrievalTimeout}) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: getEmailFromPhone(phoneNumber), password: password);
      updateUser();
      if (authResult.user != null) {
        await verifyPhoneNumber(phoneNumber: phoneNumber,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
        updateUser();
      }

      return authResult.user != null;
    } on FirebaseAuthException catch (e){
      print('signUpWithPhone error: $e');
      return e;
    }
  }


  Future verifyPhoneNumber({required String phoneNumber,
    Function(PhoneAuthCredential)? verificationCompleted,
    Function(FirebaseAuthException)? verificationFailed,
    Function(String, int?)? codeSent,
    Function(String)? codeAutoRetrievalTimeout,
    int? resendToken}) async {
    return await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) {
          print("VerificationCompleted called");
          _auth.currentUser?.linkWithCredential(credential);
          verificationCompleted?.call(credential);
        },
        verificationFailed: (exception) {
          print('verifyPhoneNumber Failed: ${exception.toString()}');
          verificationFailed?.call(exception);
        },
        codeSent: (verificationId, resendToken) {
          codeSent?.call(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          codeAutoRetrievalTimeout?.call(verificationId);
        },
        forceResendingToken: resendToken);
  }

  Future linkPhoneCredential(
      {required String verificationId, required String smsCode}) async {
    try {
      await _auth.currentUser?.linkWithCredential(PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode));
      _auth.currentUser?.reload();
      updateUser();
      return true;
    } catch (e) {
      print('linkPhoneCredential error: $e');
      return e;
    }
  }

  Future<bool> login({required String phoneNumber, required String password}) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: getEmailFromPhone(phoneNumber), password: password);
      updateUser();
      return result.user != null;
    } catch (e) {
      print('login error: $e');
      return false;
    }
  }

  void logOut() async {
    if (_auth.currentUser != null) {
      await _auth.signOut();
      updateUser();
    }
  }

  void updateUser() {
    _currentUser = _auth.currentUser;
  }

  bool isPhoneVerified() {
    //TODO: create more robust phone verified check
    return _auth.currentUser!.providerData.any((element) {
      return element.email == null && element.phoneNumber != null;
    });
  }

  static getEmailFromPhone(String phoneNumber){
    return '$phoneNumber@group-lunch-app.com';
  }
}