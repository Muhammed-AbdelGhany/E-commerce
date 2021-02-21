import 'package:e_commerce/providers/products.dart';
import 'package:e_commerce/screens/edit_product_screen.dart';
import 'package:e_commerce/widgets/app_drawer.dart';
import 'package:e_commerce/widgets/user_products_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products-screen';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
          itemCount: productData.items.length,
          itemBuilder: (_, i) => Column(
                children: [
                  UserProductsItem(
                    id: productData.items[i].id,
                    title: productData.items[i].title,
                    imageUrl: productData.items[i].imageUrl,
                  ),
                  Divider()
                ],
              )),
    );
  }
}
