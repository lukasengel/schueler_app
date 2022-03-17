import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './local_data.dart';
import './web_data.dart';
import './notifications.dart';

import '../models/auth_data_exception.dart';

enum AuthState { LOGGED_IN, LOGGED_OFF }

class Authentication extends GetxController {
  String error = "";
  Rx<AuthState> authState = AuthState.LOGGED_OFF.obs;
  late Rx<User?> firebaseUser;

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    firebaseUser.bindStream(FirebaseAuth.instance.userChanges());
  }

  void changeState(User? user) {
    if (user == null) {
      authState.value = AuthState.LOGGED_OFF;
    } else {
      authState.value = AuthState.LOGGED_IN;
    }
    update();
  }

  Future<void> login() async {
    error = "";
    final webData = Get.find<WebData>();
    final localData = Get.find<LocalData>();
    final notifications = Get.find<Notifications>();

    try {
      if (localData.settings.username.isEmpty ||
          localData.settings.password.isEmpty) {
        throw (AuthDataException.emptyCredentials());
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: localData.settings.username + "@example.com",
        password: localData.settings.password,
      );
      await webData.fetchData();
      await notifications.manageSubscriptions();
      ever(firebaseUser, changeState);
      authState.value = AuthState.LOGGED_IN;
    } on FirebaseAuthException catch (e) {
      error = e.message ?? e.toString();
    } catch (e) {
      error = e.toString();
    }
    update();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
