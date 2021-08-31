import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codespot/config/paths.dart';
import 'package:codespot/models/models.dart';
import 'package:codespot/repositories/auth/base-auth-repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository extends BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firebaseFirestore;

  AuthRepository({
    auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firebaseFirestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  // @override
  // Future<String> verifyPhoneNumber({
  //   required String phoneNumber,
  // }) async {
  //   try {

  //   } on auth.FirebaseAuthException catch (err) {
  //     throw Failure(code: err.code, message: err.message ?? "");
  //   } on PlatformException catch (err) {
  //     throw Failure(code: err.code, message: err.message ?? "");
  //   }
  // }

  @override
  Future<auth.User?> continueWithPhone({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      auth.PhoneAuthCredential credential = auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCred = await _firebaseAuth.signInWithCredential(credential);
      final user = userCred.user;
      await _firebaseFirestore.collection(Paths.users).add({
        "codeName":"",
        "uid":user?.uid,
        "phoneNumber":user?.phoneNumber,
        "cordinates":GeoPoint(554,445)

      });
      return userCred.user;
    } on auth.FirebaseAuthException catch (e) {
      throw Failure(message: e.message ?? "", code: e.code);
    } on PlatformException catch (e) {
      throw Failure(message: e.message ?? "", code: e.code);
    }
  }

  @override
  Stream<auth.User?> get userChanged => _firebaseAuth.userChanges();

  @override
  Future<auth.User?> loginWithGoogleAccount() async {
    try {
      GoogleSignInAccount? signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication signInAuthentication =
          await signInAccount!.authentication;
      auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
          accessToken: signInAuthentication.accessToken,
          idToken: signInAuthentication.idToken);

      final authResult = await _firebaseAuth.signInWithCredential(credential);
      final user = authResult.user;

      return user;
    } on auth.FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message ?? "");
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message ?? "");
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
