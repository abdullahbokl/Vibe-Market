import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/product_entities.dart';

mixin ProductRepositoryUtils {
  bool looksLikeUuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-'
      r'[0-9a-fA-F]{4}-'
      r'[0-9a-fA-F]{4}-'
      r'[0-9a-fA-F]{4}-'
      r'[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }

  List<ProductSummary> orderProducts(List<String> productIds, List<ProductSummary> results) {
    final Map<String, ProductSummary> resultMap = {for (var p in results) p.id: p};
    return productIds.map((id) => resultMap[id]).whereType<ProductSummary>().toList();
  }

  Either<Failure, ProductDetail> networkFailure() {
    return const Left(Failure.network('Product detail could not be loaded right now.'));
  }

  Either<Failure, ProductDetail> notFound() {
    return const Left(Failure.notFound('That product is no longer in the current drop window.'));
  }
}
