import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_drop_bloc.dart';

class ProductDetailHighlights extends StatelessWidget {
  const ProductDetailHighlights({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProductDropBloc, ProductDropState, List<String>>(
      selector: (ProductDropState state) =>
          state.product?.highlights ?? const <String>[],
      builder: (BuildContext context, List<String> highlights) {
        if (highlights.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Highlights', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...highlights.map((String value) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.stars_rounded, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(value)),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
