import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future logout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  static String? getCurrentUserId() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.uid;
  }
}
