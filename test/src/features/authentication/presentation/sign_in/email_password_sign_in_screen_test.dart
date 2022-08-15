import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  const kTestEmail = 'test@test.com';
  const kTestPassword = '123';
  final kTestUser = AppUser(
    uid: kTestEmail.split('').reversed.join(),
    email: kTestEmail,
  );

  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  group("sign in", () {
    testWidgets(
      """
      GIVEN formType is signIn
      WHEN tap on sign-in button
      THEN signInWithEmailAndPassword is not called.
      """,
      (WidgetTester tester) async {
        final robot = AuthRobot(tester: tester);
        await robot.pumpEmailPasswordSignInContents(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn,
        );
        await robot.tapEmailAndPasswordSubmitButton();
        verifyNever(
          () => authRepository.signInWithEmailAndPassword(
            any(),
            any(),
          ),
        );
      },
    );

    testWidgets(
      """
      GIVEN formType is signIn
      WHEN enter valid email password
      AND tap on sign-in button
      THEN signInWithEmailAndPassword is not called
      AND onSignedIn callback is called
      AND error alert is not called.
      """,
      (WidgetTester tester) async {
        bool didSignIn = false;
        final robot = AuthRobot(tester: tester);
        when(
          () => authRepository.signInWithEmailAndPassword(
              kTestEmail, kTestPassword),
        ).thenAnswer((_) => Future.value());
        await robot.pumpEmailPasswordSignInContents(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn,
          onSignedIn: () => didSignIn = true,
        );
        await robot.enterEmail(kTestEmail);
        await robot.enterPassword(kTestPassword);
        await robot.tapEmailAndPasswordSubmitButton();
        verify(
          () => authRepository.signInWithEmailAndPassword(
            kTestEmail,
            kTestPassword,
          ),
        ).called(1);
        robot.expectErrorAlertNotFound();
        expect(didSignIn, true);
      },
    );
  });
}
