import 'package:e_commerce/widgets/cart_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                        fontSize: Theme.of(context).textTheme.title.fontSize),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                      onPressed: () {},
                      child: Text('Order Now',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartProduct(
              id: cart.items.values.toList()[i].id,
              productId: cart.items.keys.toList()[i],
              price: cart.items.values.toList()[i].price,
              title: cart.items.values.toList()[i].title,
              quantity: cart.items.values.toList()[i].quantity,
            ),
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}
