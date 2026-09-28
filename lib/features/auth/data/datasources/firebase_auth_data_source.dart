import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/app_user.dart';

/// Thin wrapper around FirebaseAuth + GoogleSignIn. This is the only file in
/// the app that talks to those SDKs directly; everything else goes through
/// [AuthRepository].
class FirebaseAuthDataSource {
  FirebaseAuthDataSource({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  bool _googleSignInInitialized = false;

  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  AppUser? get currentUser => _mapUser(_firebaseAuth.currentUser);

  Future<void> signInWithEmail({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password);
  }

  Future<void> signUpWithEmail({required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email.trim(), password: password);
  }

  Future<void> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();
    final account = await _googleSignIn.authenticate();
    final idToken = account.authentication.idToken;
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    if (_googleSignInInitialized) {
      await _googleSignIn.signOut();
    }
  }

  Future<void> deleteAccount() async {
    await _firebaseAuth.currentUser?.delete();
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await _googleSignIn.initialize();
    _googleSignInInitialized = true;
  }

  AppUser? _mapUser(User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      isEmailVerified: user.emailVerified,
    );
  }
}
