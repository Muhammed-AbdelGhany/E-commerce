import 'package:e_commerce/providers/products.dart';
import 'package:flutter/material.dart';
import 'product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool isfav;
  ProductsGrid(this.isfav);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final porducts = isfav ? productsData.favItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: porducts[index],
          child: ProductItem(
              // id: porducts[index].id,
              // imageUrl: porducts[index].imageUrl,
              // title: porducts[index].title,
              ),
        );
      },
      itemCount: porducts.length,
    );
  }
}
