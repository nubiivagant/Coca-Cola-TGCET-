import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<User?> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    final UserCredential userCredential = await _auth.signInWithProvider(appleProvider);
    return userCredential.user;
  }

  Future<User?> signInWithFacebook() async {
    final facebookProvider = FacebookAuthProvider();
    final UserCredential userCredential = await _auth.signInWithProvider(facebookProvider);
    return userCredential.user;
  }
}