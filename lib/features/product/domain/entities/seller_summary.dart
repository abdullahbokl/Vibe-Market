import 'package:equatable/equatable.dart';

class SellerSummary extends Equatable {
  const SellerSummary({
    required this.id,
    required this.handle,
    required this.displayName,
  });

  final String id;
  final String handle;
  final String displayName;

  @override
  List<Object?> get props => <Object?>[id, handle, displayName];
}
