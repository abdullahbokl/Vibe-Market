import 'package:equatable/equatable.dart';

class ProductMedia extends Equatable {
  const ProductMedia({required this.id, required this.url, required this.type});

  final String id;
  final String url;
  final String type;

  @override
  List<Object?> get props => <Object?>[id, url, type];
}
