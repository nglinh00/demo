import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});

  group('Fake Auth Repository', () {
    test(
      "getProducts return a global list",
      () async {
        final productRepository = FakeProductsRepository();
        expect(
          productRepository.getProductsList(),
          kTestProducts,
        );
      },
    );

    test(
      "getProduct(1) return first item",
      () async {
        final productRepository = FakeProductsRepository();
        expect(
          productRepository.getProduct('1'),
          kTestProducts[0],
        );
      },
    );

    test(
      "getProduct(100) should return null",
      () async {
        final productRepository = FakeProductsRepository();

        //! If you need to test a function that throws [Exception]/[Error]
        //! => Put it inside closure.
        //! This will ensure it is called lazily by the expect method.
        //! Which mean expect method will catch the exception.
        //!
        //! Case:
        //!   Product? getProduct(String id) {
        //!     return _products.firstWhere((product) => product.id == id);
        //!   }
        //! Solution:
        expect(
          () => productRepository.getProduct('100'),
          throwsStateError,
        );

        //! Otherwise, if you put function insisde try/catch block
        //! Case:
        //!   Product? getProduct(String id) {
        //!     try {
        //!       return _products.firstWhere((product) => product.id == id);
        //!     } catch (e) {
        //!       return null;
        //!     }
        //!   }
        //! Solution:
        expect(
          productRepository.getProduct('100'),
          null,
        );
      },
    );

    test(
      "fetchProductsList return global list",
      () async {
        final productRepository = FakeProductsRepository();

        expect(
          await productRepository.fetchProductsList(),
          kTestProducts,
        );
      },
    );

    test(
      "watchProductsList emits global list",
      () async {
        final productRepository = FakeProductsRepository();
        //! To test a stream, we need a StreamMatcher
        expect(
          productRepository.watchProductsList(),
          emits(kTestProducts),
        );
      },
    );

    test(
      "watchProduct(1) emits the first item",
      () async {
        final productRepository = FakeProductsRepository();

        expect(
          productRepository.watchProduct('1'),
          emits(kTestProducts[0]),
        );
      },
    );

    test(
      "watchProduct(100) emits null",
      () async {
        final productRepository = FakeProductsRepository();

        expect(
          productRepository.watchProduct('100'),
          emits(null),
        );
      },
    );
  });
}
