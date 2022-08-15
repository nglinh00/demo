import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  const kTestEmail = 'test@test.com';
  const kTestPassword = '123';
  final kTestUser =
      AppUser(uid: kTestEmail.split('').reversed.join(), email: kTestEmail);
  testWidgets(
    'Cancel logout',
    (tester) async {
      final authRobot = AuthRobot(tester: tester);
      await authRobot.pumpAccountScreen();
      await authRobot.tapLogoutButton();
      authRobot.expectLogoutDialogFound();
      await authRobot.tapCancelButton();
      authRobot.expectLogoutDialogNotFound();
    },
  );

  testWidgets(
    "Confirm logout success",
    (WidgetTester tester) async {
      final authRobot = AuthRobot(tester: tester);
      await authRobot.pumpAccountScreen();
      await authRobot.tapLogoutButton();
      authRobot.expectLogoutDialogFound();
      await authRobot.tapDialogLogoutButton();
      authRobot.expectLogoutDialogNotFound();
    },
  );

  testWidgets(
    "Confirm logout failure",
    (WidgetTester tester) async {
      final authRepository = MockAuthRepository();
      final authRobot = AuthRobot(tester: tester);
      final exception = Exception("Connection failed");
      when(authRepository.signOut).thenThrow(exception);
      when(authRepository.authStateChanges).thenAnswer(
        (_) => Stream.value(kTestUser),
      );

      await authRobot.pumpAccountScreen(authRepository: authRepository);
      await authRobot.tapLogoutButton();
      authRobot.expectLogoutDialogFound();
      await authRobot.tapDialogLogoutButton();
      authRobot.expectLogoutDialogNotFound();
      authRobot.expectErrorAlertFound();
    },
  );

  testWidgets(
    "Confirm logout loading state",
    (WidgetTester tester) async {
      final authRepository = MockAuthRepository();
      final authRobot = AuthRobot(tester: tester);
      when(authRepository.signOut).thenAnswer(
        (_) => Future.delayed(const Duration(seconds: 1)),
      );
      when(authRepository.authStateChanges).thenAnswer(
        (_) => Stream.value(kTestUser),
      );

      // Future.delayed probably uses a Timer internally.
      // flutter_test uses a fake clock.
      // When you call pump(), there's an argument you can pass
      // that says by how much to advance the clock.
      // Since you passed nothing, it defaults to zero time,
      // and doesn't advance the clock.
      // If you pass it a duration of, say, 1 second,
      // it will trigger the delayed future.
      //! https://github.com/flutter/flutter/issues/11181
      //! https://stackoverflow.com/questions/54021267/test-breaks-when-using-future-delayed
      await tester.runAsync(() async {
        await authRobot.pumpAccountScreen(authRepository: authRepository);
        await authRobot.tapLogoutButton();
        authRobot.expectLogoutDialogFound();
        await authRobot.tapDialogLogoutButton();
        authRobot.expectLogoutDialogNotFound();
      });

      authRobot.expectCircularProgressIndicator();
    },
  );
}
