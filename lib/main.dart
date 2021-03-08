import 'package:e_commerce/providers/auth.dart';
import 'package:e_commerce/providers/cart.dart';
import 'package:e_commerce/providers/orders.dart';
import 'package:e_commerce/providers/products.dart';
import 'package:e_commerce/screens/auth_screen.dart';
import 'package:e_commerce/screens/cart_screen.dart';
import 'package:e_commerce/screens/edit_product_screen.dart';
import 'package:e_commerce/screens/orders_screen.dart';
import 'package:e_commerce/screens/product_details_screen.dart';
import 'package:e_commerce/screens/product_overall_screen.dart';
import 'package:e_commerce/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products('', '', []),
          update: (ctx, auth, previousProducts) =>
              Products(auth.token, auth.userId, previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders('', []),
          update: (ctx, auth, previousOrders) =>
              Orders(auth.token, previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato",
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth ? ProductOverallScreen() : AuthScreen(),
          routes: {
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
