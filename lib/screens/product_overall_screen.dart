import 'package:e_commerce/providers/product.dart';
import 'package:e_commerce/widgets/product_item.dart';
import 'package:e_commerce/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import '../providers/product.dart';

enum FilterOptions {
  Favorits,
  All,
}

class ProductOverallScreen extends StatefulWidget {
  @override
  _ProductOverallScreenState createState() => _ProductOverallScreenState();
}

class _ProductOverallScreenState extends State<ProductOverallScreen> {
  bool isFavoriteSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorits) {
                    isFavoriteSelected = true;
                  } else {
                    isFavoriteSelected = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (ctx) => [
                    PopupMenuItem(
                      child: Text('Favotrites'),
                      value: FilterOptions.Favorits,
                    ),
                    PopupMenuItem(
                      child: Text('All'),
                      value: FilterOptions.All,
                    ),
                  ])
        ],
      ),
      body: ProductsGrid(isFavoriteSelected),
    );
  }
}
