import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const kDuration = Duration(seconds: 1);

  late MockAuthRepository authRepository;
  late AccountScreenController controller;

  setUp(() {
    authRepository = MockAuthRepository();
    controller = AccountScreenController(authRepository: authRepository);
  });

  group('Account Screen Controller', () {
    test(
      "init state is AsyncValue.data",
      () async {
        // Set up
        // Run
        // Verify
        verifyNever(authRepository.signOut);
        expect(
          controller.debugState,
          const AsyncValue<void>.data(null),
        );
      },
    );

    test(
      "sign out success",
      () async {
        // Set up

        //! Set up method inside repository
        when(authRepository.signOut).thenAnswer(
          (_) => Future.value(),
        );

        //! Test state
        //! If we write like this, we will need timeout
        //! to ensure our test fail fast when need.
        expectLater(
          controller.stream,
          emitsInOrder(const [
            AsyncLoading<void>(),
            AsyncData<void>(null),
          ]),
        );

        // Run
        await controller.signOut();

        // Verify
        verify(authRepository.signOut).called(1);
        //! This is optional
        expect(
          controller.debugState,
          const AsyncValue<void>.data(null),
        );
      },
      //! This is optinal
      timeout: const Timeout(kDuration),
    );

    test(
      "signOut failure",
      () async {
        // Set up
        final exception = Exception('Connection failed');
        when(authRepository.signOut).thenThrow(exception);

        //! Test state
        //! If we write like this, we will need timeout
        //! to ensure our test fail fast when need.
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            // If we use AsyncError<void>(null),
            // we will get an exception
            // that error throws include (e, stacktrace)
            // but our exception has only `e`
            // so we use predicate instead.
            predicate<AsyncError<void>>((value) {
              //! There're 2 way to test error.
              //! 1.
              expect(value.hasError, true);
              //! 2.
              expect(value, isA<AsyncError<void>>());
              return true;
            })
          ]),
        );

        // Run
        await controller.signOut();
        // Verify
        verify(authRepository.signOut).called(1);
        //! This is optional
        //! There're 2 ways to test error.
        //! 1.
        expect(
          controller.debugState.hasError,
          true,
        );
        //! 2.
        expect(
          controller.debugState,
          isA<AsyncError>(),
        );
      },
      //! This is optinal
      timeout: const Timeout(kDuration),
    );
  });
}
