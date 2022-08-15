import 'package:flutter_test/flutter_test.dart';

import '../robot.dart';

void main() {
  setUp(() {});

  group("", () {
    testWidgets(
      "Sign in and sign out flow",
      (WidgetTester tester) async {
        final robot = Robot(tester: tester);
        await robot.pumpMyApp();
      },
    );
  });
}
