import 'package:e_commerce/providers/cart.dart';
import 'package:e_commerce/providers/products.dart';
import 'package:e_commerce/screens/cart_screen.dart';
import 'package:e_commerce/widgets/app_drawer.dart';
import 'package:e_commerce/widgets/badge.dart';
import 'package:e_commerce/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isLoading = true;
    });
    Provider.of<Products>(context, listen: false).fetchData().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

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
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(width: 20.0, height: 100.0),
                  SpinKitDualRing(color: Theme.of(context).primaryColor),
                  SizedBox(width: 20.0, height: 100.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "LOADING",
                        style: TextStyle(fontSize: 40),
                      ),
                      SizedBox(width: 20.0, height: 100.0),
                      RotateAnimatedTextKit(
                          duration: Duration(milliseconds: 200),
                          text: [".", "..", "..."],
                          textStyle:
                              TextStyle(fontSize: 40.0, fontFamily: "Horizon"),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
            )
          //   child: SpinKitDualRing(
          //   color: Theme.of(context).primaryColor,
          //   size: 50.0,
          // ))
          : ProductsGrid(isFavoriteSelected),
    );
  }
}
