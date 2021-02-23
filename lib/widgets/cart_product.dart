import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import 'badge.dart';

class CartProduct extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartProduct({this.id, this.productId, this.title, this.price, this.quantity});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id),
      background: Container(
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (dismissDirection) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Product Deletion'),
                  content:
                      Text('Are you sure you want to delete this product?'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text('No'),
                    ),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text('Yes'))
                  ],
                ));
      },
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).onDismiss(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(child: FittedBox(child: Text('\$$price'))),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('x$quantity'),
          ),
        ),
      ),
    );
  }
}
