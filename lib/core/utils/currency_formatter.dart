import 'package:intl/intl.dart';

String formatPrice({required int priceCents, required String currencyCode}) {
  final NumberFormat formatter = NumberFormat.simpleCurrency(
    name: currencyCode,
  );
  return formatter.format(priceCents / 100);
}
