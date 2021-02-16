import 'package:e_commerce/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = "/product-details";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final selectedProduct =
        Provider.of<Products>(context, listen: false).getProductById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                selectedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('\$${selectedProduct.price}', style: TextStyle(fontSize: 28)),
            Container(
              child: Text(
                selectedProduct.description,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              margin: EdgeInsets.all(10),
              width: double.infinity,
            )
          ],
        ),
      ),
    );
  }
}
