@Timeout(Duration(seconds: 1))
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const kTestEmail = 'test@test.com';
  const kTestPassword = '123';
  final kTestUser =
      AppUser(uid: kTestEmail.split('').reversed.join(), email: kTestEmail);

  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  group("submit", () {
    test(
      """
      Given formType is signIn 
      When signInWithEmailAndPassword succeeds 
      Then return true 
      And state is AsyncData.
      """,
      () async {
        // Set up
        final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository,
        );
        when(
          () => authRepository.signInWithEmailAndPassword(
            kTestEmail,
            kTestPassword,
          ),
        ).thenAnswer((_) => Future.value());

        expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncLoading<void>(),
            ),
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncData<void>(null),
            ),
          ]),
        );
        // Run
        final result = await controller.submit(kTestEmail, kTestPassword);
        // Verify
        expect(result, true);
      },
    );

    test(
      """
      Given formType is signIn 
      When signInWithEmailAndPassword fails 
      Then return false 
      And state is AsyncError.
      """,
      () async {
        final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository,
        );
        final exception = Exception('Connection Failed.');
        // Set up
        when(
          () => authRepository.signInWithEmailAndPassword(
            kTestEmail,
            kTestPassword,
          ),
        ).thenThrow(exception);

        expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncLoading<void>(),
            ),
            predicate<EmailPasswordSignInState>((state) {
              expect(state.formType, EmailPasswordSignInFormType.signIn);
              expect(state.value, isA<AsyncError>());
              return true;
            })
          ]),
        );
        // Run
        final result = await controller.submit(kTestEmail, kTestPassword);
        // Verify
        expect(result, false);
      },
    );

    test(
      """
      Given formType is register 
      When createUserWithEmailAndPassword succeeds 
      Then return true 
      And state is AsyncData.
      """,
      () async {
        final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.register,
          authRepository: authRepository,
        );
        // Set up
        when(
          () => authRepository.createUserWithEmailAndPassword(
            kTestEmail,
            kTestPassword,
          ),
        ).thenAnswer((_) => Future.value());

        expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncLoading<void>(),
            ),
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncData<void>(null),
            ),
          ]),
        );
        // Run
        final result = await controller.submit(kTestEmail, kTestPassword);
        // Verify
        expect(result, true);
      },
    );

    test(
      """
      Given formType is register 
      When createUserWithEmailAndPassword fails 
      Then return false 
      And state is AsyncError.
      """,
      () async {
        final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.register,
          authRepository: authRepository,
        );
        final exception = Exception('Connection Failed.');
        // Set up
        when(
          () => authRepository.createUserWithEmailAndPassword(
            kTestEmail,
            kTestPassword,
          ),
        ).thenThrow(exception);

        expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncLoading<void>(),
            ),
            predicate<EmailPasswordSignInState>((state) {
              expect(state.formType, EmailPasswordSignInFormType.register);
              expect(state.value, isA<AsyncError>());
              return true;
            })
          ]),
        );
        // Run
        final result = await controller.submit(kTestEmail, kTestPassword);
        // Verify
        expect(result, false);
      },
    );
  });

  group("updateFormType", () {
    test(
      """
      Given formType is signIn
      When called with register
      Then state.formType is register.
      """,
      () async {
        // Set up
        final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository,
        );
        // Run
        controller.updateFormType(EmailPasswordSignInFormType.register);
        // Verify
        //! There're 2 ways to test
        //! 1.
        expect(
          controller.state.formType,
          EmailPasswordSignInFormType.register,
        );
        //! 2.
        expect(
          controller.debugState,
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncData<void>(null),
          ),
        );
      },
    );

    test(
      """
      Given formType is register
      When called with signIn
      Then state.formType is signIn.
      """,
      () async {
        // Set up
        final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.register,
          authRepository: authRepository,
        );
        // Run
        controller.updateFormType(EmailPasswordSignInFormType.signIn);
        // Verify
        //! There're 2 ways to test
        //! 1.
        expect(
          controller.state.formType,
          EmailPasswordSignInFormType.signIn,
        );
        //! 2.
        expect(
          controller.debugState,
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncData<void>(null),
          ),
        );
      },
    );
  });
}
