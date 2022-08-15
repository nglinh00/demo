import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const kTestEmail = 'test@test.com';
  const kTestPassword = '123';
  final kTestUser =
      AppUser(uid: kTestEmail.split('').reversed.join(), email: kTestEmail);

  setUp(() {});

  group('fake auth repository', () {
    test(
      "currentUser is null",
      () async {
        final authRepository = FakeAuthRepository();
        addTearDown(authRepository.dispose);
        expect(authRepository.currentUser, null);
        expect(authRepository.authStateChanges(), emits(null));
      },
    );

    test(
      "currentUser is not null after sign in",
      () async {
        final authRepository = FakeAuthRepository();
        addTearDown(authRepository.dispose);
        await authRepository.signInWithEmailAndPassword(
          kTestEmail,
          kTestPassword,
        );
        expect(authRepository.currentUser, kTestUser);
        expect(authRepository.authStateChanges(), emits(kTestUser));
      },
    );

    test(
      "currentUser is not null after registration",
      () async {
        final authRepository = FakeAuthRepository();
        addTearDown(authRepository.dispose);
        await authRepository.createUserWithEmailAndPassword(
          kTestEmail,
          kTestPassword,
        );
        expect(authRepository.currentUser, kTestUser);
        expect(authRepository.authStateChanges(), emits(kTestUser));
      },
    );

    test(
      "currentUser is null after sign out",
      () async {
        final authRepository = FakeAuthRepository();
        addTearDown(authRepository.dispose);

        await authRepository.signInWithEmailAndPassword(
          kTestEmail,
          kTestPassword,
        );

        //! Check currentUser is valid before sign out
        expect(authRepository.currentUser, kTestUser);
        expect(authRepository.authStateChanges(), emits(kTestUser));

        await authRepository.signOut();

        //! After sign out, currentUser is null
        expect(authRepository.currentUser, null);
        expect(authRepository.authStateChanges(), emits(null));
      },
    );

    test(
      "sign in after dispose throws exception",
      () async {
        final authRepository = FakeAuthRepository();
        authRepository.dispose();

        expect(
          () => authRepository.signInWithEmailAndPassword(
            kTestEmail,
            kTestPassword,
          ),
          throwsStateError,
        );
      },
    );
  });
}
