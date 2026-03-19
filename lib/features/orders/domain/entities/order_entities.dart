import 'package:equatable/equatable.dart';

class OrderSummary extends Equatable {
  const OrderSummary({
    required this.id,
    required this.title,
    required this.amountCents,
    required this.currencyCode,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String title;
  final int amountCents;
  final String currencyCode;
  final String status;
  final DateTime createdAt;

  @override
  List<Object?> get props => <Object?>[
    id,
    title,
    amountCents,
    currencyCode,
    status,
    createdAt,
  ];
}
