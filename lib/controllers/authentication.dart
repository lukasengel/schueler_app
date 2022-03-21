import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './notifications.dart';
import './web_data.dart';
import './local_data.dart';

import '../models/exceptions/auth_data_exception.dart';

enum AuthState { LOGGED_IN, LOGGED_OFF }

class Authentication extends GetxController {
  Rx<AuthState> authState = AuthState.LOGGED_OFF.obs;
  late Rx<User?> firebaseUser;

  @override
  void onInit() {
    firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    firebaseUser.bindStream(FirebaseAuth.instance.userChanges());
    super.onInit();
  }

  void changeState(User? user) {
    authState.value = user == null ? AuthState.LOGGED_OFF : AuthState.LOGGED_IN;
    update();
  }

  Future<void> login() async {
    final localData = Get.find<LocalData>();
    final notifications = Get.find<Notifications>();
    final webData = Get.find<WebData>();

    try {
      if (localData.settings.username.isEmpty ||
          localData.settings.password.isEmpty) {
        throw (AuthDataException.emptyCredentials());
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: localData.settings.username + "@example.com",
        password: localData.settings.password,
      );
      await notifications.initialize();
      await webData.fetchData();
      authState.value = AuthState.LOGGED_IN;
      notifications.manageSubscription();
      ever(firebaseUser, changeState);
    } on FirebaseAuthException catch (e) {
      localData.error = e.message;
    } catch (e) {
      localData.error = e.toString();
    }
    update();
  }

  Future<void> signOut() => FirebaseAuth.instance.signOut();
}
