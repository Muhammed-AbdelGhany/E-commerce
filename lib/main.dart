import 'package:e_commerce/providers/products.dart';
import 'package:e_commerce/screens/product_details_screen.dart';
import 'package:e_commerce/screens/product_overall_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Products(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: "Lato",
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductOverallScreen(),
        routes: {
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen()
        },
      ),
    );
  }
}
