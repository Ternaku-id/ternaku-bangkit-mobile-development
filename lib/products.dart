import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  final List<dynamic>? products;

  const ProductsPage({required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: products?.length ?? 0,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(
              products?[index]['name'] ?? '',
            ),
            subtitle: Text(
              products?[index]['description'] ?? '',
            ),
          ),
        );
      },
    );
  }
}
