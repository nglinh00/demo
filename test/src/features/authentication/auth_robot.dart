import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';

class AuthRobot {
  AuthRobot({
    required this.tester,
  });
  WidgetTester tester;

  Future<void> pumpAccountScreen({FakeAuthRepository? authRepository}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (authRepository != null)
            authRepositoryProvider.overrideWithValue(
              authRepository,
            ),
        ],
        child: const MaterialApp(
          home: AccountScreen(),
        ),
      ),
    );
  }

  Future<void> pumpEmailPasswordSignInContents({
    FakeAuthRepository? authRepository,
    required EmailPasswordSignInFormType formType,
    VoidCallback? onSignedIn,
  }) async {
    return await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (authRepository != null)
            authRepositoryProvider.overrideWithValue(
              authRepository,
            ),
        ],
        child: MaterialApp(
          home: EmailPasswordSignInContents(
            formType: formType,
            onSignedIn: onSignedIn,
          ),
        ),
      ),
    );
  }

  Future<void> enterEmail(String email) async {
    final emailField = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);
  }

  Future<void> enterPassword(String password) async {
    final passwordField = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, password);
  }

  Future<void> tapEmailAndPasswordSubmitButton() async {
    final primaryButton = find.byType(PrimaryButton);
    expect(primaryButton, findsOneWidget);
    await tester.tap(primaryButton);
    await tester.pump();
  }

  Future<void> tapLogoutButton() async {
    final logoutButton = find.text("Logout");
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    //! The test enviroment does NOT update UI
    //! after we perform an interaction. (in this case is tap button)
    //! tester.pump() will trigger a new frame.
    await tester.pump();
  }

  Future<void> tapCancelButton() async {
    final cancelButton = find.text("Cancel");
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);
    await tester.pump();
  }

  Future<void> tapDialogLogoutButton() async {
    final logoutButton = find.byKey(kDefaultDialogKey);
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pump();
  }

  void expectLogoutDialogFound() {
    final dialogTitle = find.text("Are you sure?");
    expect(dialogTitle, findsOneWidget);
  }

  void expectLogoutDialogNotFound() {
    final dialogTitle = find.text("Are you sure?");
    expect(dialogTitle, findsNothing);
  }

  void expectErrorAlertFound() {
    final errorAlert = find.text("Error");
    expect(errorAlert, findsOneWidget);
  }

  void expectErrorAlertNotFound() {
    final errorAlert = find.text("Error");
    expect(errorAlert, findsNothing);
  }

  void expectCircularProgressIndicator() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }
}
