import 'package:e_commerce/providers/product.dart';
import 'package:e_commerce/widgets/product_item.dart';
import 'package:e_commerce/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import '../providers/product.dart';

class ProductOverallScreen extends StatelessWidget {
  final List<Product> loadedProducts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
      ),
      body: ProductsGrid(),
    );
  }
}
