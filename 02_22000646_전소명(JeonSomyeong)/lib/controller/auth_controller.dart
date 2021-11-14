import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moappfinal/auth/user_init.dart';

class AuthController extends GetxController {
  bool loading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> _firebaseUser = Rx<User?>(null);
  UserInit userInit = UserInit();

  User? get user => _firebaseUser.value;

  @override
  onInit() {
    _firebaseUser.bindStream(_auth
        .authStateChanges()); // binding auth stream from firebase to the user

    ever(_firebaseUser, (User? value) {
      print("Status Updated :: $value?.uid");
      print(value);

      // Check if new user uid is same as curr user.
      if (userInit.uid != null && (value?.uid) != userInit.uid) {
        print("Something went wrong with current user. Logging out.");
        Get.snackbar("유저 정보에 오류가 발생했습니다", "다시 로그인해주세요.");
      }

      // Reroute
      if (value == null) {
        Get.offAllNamed("/login");
      } else {
        userInit.getUser(value, value.isAnonymous);
      }
    });

    super.onInit();
  }

  final _googleSignIn = GoogleSignIn();

  Future signInAnon() async {
    try {
      await _auth.signInAnonymously();
      Get.offAllNamed("/"); // Back to Home
      print(_firebaseUser);
    } catch (e) {
      Get.snackbar("Error signing in anonymously", "e.message",
          snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }

  Future signInGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;
      assert(!user!.isAnonymous);
      assert(await user!.getIdToken() != null);
      final User? currentUser = _auth.currentUser;
      assert(user!.uid == currentUser!.uid);
      print(_firebaseUser);
      Get.offAllNamed("/"); // Back to Home
      return;
    } catch (e) {
      Get.snackbar("Error signing in with Google", "e.message",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      return await _auth.signOut();
    } catch (e) {
      Get.snackbar("Error logging out", "e.message",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
  }
}
