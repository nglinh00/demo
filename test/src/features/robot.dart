import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class Robot {
  Robot({
    required this.tester,
  });
  WidgetTester tester;

  Future<void> pumpMyApp() async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  }

  void expectFindAllProducts() {
    final finder = find.byType(ProductCard);
    expect(finder, findsNWidgets(kTestProducts.length));
  }
}
