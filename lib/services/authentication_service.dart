import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  User? get currentUser => _currentUser;

  Stream<User?> get authSubscription => _auth.authStateChanges();

  /// Returns [UserCredential] if account creation succeeds
  /// return [FirebaseAuthException] on failure
  Future<dynamic> signUpWithPhone({required String phoneNumber, required String password,
    Function(PhoneAuthCredential)? verificationCompleted,
    Function(FirebaseAuthException)? verificationFailed,
    Function(String, int?)? codeSent,
    Function(String)? codeAutoRetrievalTimeout}) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: getEmailFromPhone(phoneNumber), password: password);
      updateUser(authResult.user);
      if (authResult.user != null) {
        final verifyResult = await verifyPhoneNumber(phoneNumber: phoneNumber,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
        updateUser(verifyResult is UserCredential ? verifyResult.user : _auth.currentUser);
      }

      return authResult;
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
      final result = await _auth.currentUser?.linkWithCredential(PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode));
      _auth.currentUser?.reload();
      updateUser(result?.user);
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
      updateUser(result.user);
      return result.user != null;
    } catch (e) {
      print('login error: $e');
      return false;
    }
  }

  void logOut() async {
    if (_auth.currentUser != null) {
      await _auth.signOut();
      updateUser(null);
    }
  }

  void updateUser(User? user) {
    _currentUser = user;
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