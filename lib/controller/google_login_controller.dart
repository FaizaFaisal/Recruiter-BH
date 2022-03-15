import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController with ChangeNotifier {
  final _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    notifyListeners();
  }

  GoogleSignInAccount? googleAccount;
  login() async {
    this.googleAccount = await _googleSignIn.signIn();
    notifyListeners();
  }

  logout() async {
    this.googleAccount = await _googleSignIn.signOut();
    notifyListeners();
  }
}
