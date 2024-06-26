import 'dart:io';
import 'package:aura/firebase_options.dart';
import 'package:aura/helpers/utils/app_logger.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthService {
  // State Variables --------------------------------------------------------------------------------
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Getters --------------------------------------------------------------------------------
  static bool get hasUser => user != null;
  static User? get user => _firebaseAuth.currentUser;

  // Methods --------------------------------------------------------------------------------
  Future<bool> isEmailToken({required String email}) async {
    List<String> data = await _firebaseAuth.fetchSignInMethodsForEmail(email);

    return data.isNotEmpty;
  }

  static Future<(bool, String?)> registerUser({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    String? error;
    bool success = false;

    try {
      assert(
        username.isNotEmpty &&
            email.isNotEmpty &&
            password.isNotEmpty &&
            confirmPassword.isNotEmpty,
        "All fields are required",
      );
      assert(username.length >= 2,
          "Please enter a valid username\n(2 or more characters)");
      assert(EmailValidator.validate(email), "Invalid email address");
      assert(password.length >= 8, "Password is too short");
      assert(password == confirmPassword, "Passwords do not match");

      // Register account after assertions
      final UserCredential user = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update user display name to chosen username
      await _firebaseAuth.currentUser?.updateDisplayName(username);

      success = true;
      AppLogger.logOne(LogItem(title: "Register Log", data: {"User: ": user}),
          type: LogType.success);
    } on AssertionError catch (e) {
      error = e.message.toString();
      AppLogger.logOne(
        LogItem(
            title: "Assertion Error", data: {"data": e, "type": e.runtimeType}),
        type: LogType.error,
      );
    } on FirebaseAuthException catch (e) {
      error = e.message;
      AppLogger.logOne(
        LogItem(
            title: "Registration Error",
            data: {"data": e, "type": e.runtimeType}),
        type: LogType.error,
      );
    }

    return (success, error);
  }

  static Future<(bool, String?)> signInUser({
    required String email,
    required String password,
  }) async {
    String? error;
    bool success = false;

    try {
      assert(
          email.isNotEmpty && password.isNotEmpty, "All fields are required");
      assert(EmailValidator.validate(email), "Invalid email address");

      final UserCredential user = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      success = true;
      AppLogger.logOne(LogItem(title: "Sign In Log", data: {"User: ": user}),
          type: LogType.success);
    } on AssertionError catch (e) {
      error = e.message.toString();
    } on FirebaseAuthException catch (e) {
      error = e.message;
      AppLogger.logOne(
        LogItem(
            title: "Sign In Error", data: {"data": e, "type": e.runtimeType}),
        type: LogType.error,
      );
    }

    return (success, error);
  }

  static Future<(bool, String?, {bool profileIncomplete})>
      signInWithGoogle() async {
    String? error;
    bool success = false;
    bool profileIncomplete = true;

    // Get client ID for IOS devices
    String? clientId = Platform.isIOS
        ? DefaultFirebaseOptions.currentPlatform.iosClientId
        : null;

    GoogleSignIn googleAuth = GoogleSignIn(clientId: clientId);

    try {
      GoogleSignInAccount? user = await googleAuth.signIn();

      if (user != null) {
        final GoogleSignInAuthentication auth = await user.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );

        final UserCredential userResponse =
            await _firebaseAuth.signInWithCredential(credential);

        success = true;
        AppLogger.logOne(
            LogItem(
                title: "Google Sign In Log", data: {"User: ": userResponse}),
            type: LogType.success);
      }
    } on FirebaseAuthException catch (e) {
      error = e.message;
      AppLogger.logOne(
        LogItem(
          title: "Firebase Auth Exception",
          data: {"data": e},
        ),
        type: LogType.error,
      );
    } on PlatformException catch (e) {
      error = "Something went wrong. Please try again.";
      AppLogger.logOne(
        LogItem(
          title: "Google Sign In Platform Exception",
          data: {"data": e},
        ),
        type: LogType.error,
      );
    } catch (e) {
      error = "Something went wrong. Please try again.";
      AppLogger.logOne(
        LogItem(
          title: "Google Sign In Other Exception",
          data: {"data": e, "type": e.runtimeType},
        ),
        type: LogType.error,
      );
    }

    return (success, error, profileIncomplete: profileIncomplete);
  }

  static Future<(bool, String?, {bool profileIncomplete})>
      signInWithApple() async {
    String? error;
    bool success = false;
    bool profileIncomplete = true;

    try {
      final List<Scope> scopes = [Scope.email, Scope.fullName];
      final oAuthProvider = OAuthProvider(AppStrings.appleAuthProvider);

      // 1. perform the sign-in request
      final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)],
      );

      if (result.status == AuthorizationStatus.authorized) {
        // 2. Get appleID credential for firebase
        final appleIdCredential = result.credential!;
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );

        // 3. Sign In with ID credentials from Apple
        await _firebaseAuth.signInWithCredential(credential);

        // 4. Get the fullname of user after sign In
        final fullName = appleIdCredential.fullName;

        // 5. Compare if fullname has content
        if (fullName != null &&
            fullName.givenName != null &&
            fullName.familyName != null) {
          final displayName = fullName.givenName! + fullName.familyName!;
          await _firebaseAuth.currentUser?.updateDisplayName(displayName);
        }

        // 5. Mark user profile as incomplete
        if (_firebaseAuth.currentUser?.displayName == null) {
          profileIncomplete = true;
        }

        // 6. Successful submission
        success = true;

        AppLogger.logOne(
          type: LogType.success,
          LogItem(
            title: "Apple Sign In Credentials",
            data: fullName?.toMap(),
          ),
        );
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      error = "";
      AppLogger.logOne(
        LogItem(
          title: "SignInWithApple Auth Exception",
          data: {"data": e},
        ),
        type: LogType.error,
      );
    } on FirebaseAuthException catch (e) {
      error = e.message;
      AppLogger.logOne(
        LogItem(
          title: "Firebase Auth Exception",
          data: {"data": e},
        ),
        type: LogType.error,
      );
    } on PlatformException catch (e) {
      error = "Something went wrong. Please try again.";
      AppLogger.logOne(
        LogItem(
          title: "Google Sign In Platform Exception",
          data: {"data": e},
        ),
        type: LogType.error,
      );
    } on MissingPluginException catch (e) {
      error = "Something went wrong. Please try again.";
      AppLogger.logOne(
        LogItem(
          title: "Missing Plugin Exception",
          data: {"data": e},
        ),
        type: LogType.error,
      );
    } catch (e) {
      error = "Something went wrong. Please try again.";
      AppLogger.logOne(
        LogItem(
          title: "Google Sign In Other Exception",
          data: {"data": e, "type": e.runtimeType},
        ),
        type: LogType.error,
      );
    }

    return (success, error, profileIncomplete: profileIncomplete);
  }

  static Future signOut() async => await _firebaseAuth.signOut();

  static Future<String?> completeProfile({
    String? email,
    String? username,
    PhoneAuthCredential? phoneNumber,
  }) async {
    try {
      if (username != null) {
        assert(username.length >= 2, "Username is invalid");
        await _firebaseAuth.currentUser?.updateDisplayName(username);
      }

      if (email != null) {
        assert(EmailValidator.validate(email), "Invalid email address");
        await _firebaseAuth.currentUser?.updateEmail(email);
      }

      if (phoneNumber != null) {
        await _firebaseAuth.currentUser?.updatePhoneNumber(phoneNumber);
      }
    } on AssertionError catch (e) {
      return e.message.toString();
    }

    return null;
  }

  static Future verifyPhoneNumber(
    String phone, {
    required Function(String, int?) onCodeSent,
    required Function(String) codeRetrievalTimeout,
    required Function(PhoneAuthCredential) onComplete,
    required Function(FirebaseAuthException) onFailed,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        codeSent: onCodeSent,
        verificationFailed: onFailed,
        verificationCompleted: onComplete,
        timeout: const Duration(minutes: 2),
        codeAutoRetrievalTimeout: codeRetrievalTimeout,
      );
    } on AssertionError catch (e) {
      // throw Exception("Error in Firebase Auth Service : ${e.message}");
      AppLogger.logOne(
        LogItem(
          title: "Firebase Auth Service Error",
          data: {"data": e},
        ),
        type: LogType.error,
      );
    }
  }
}
