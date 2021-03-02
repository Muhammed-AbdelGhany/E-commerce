import 'package:e_commerce/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductsItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductsItem({this.id, this.title, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName,
                    arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                  } catch (error) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                color: Theme.of(context).errorColor),
          ],
        ),
      ),
    );
  }
}
