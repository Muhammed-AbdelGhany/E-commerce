import 'package:e_commerce/widgets/app_drawer.dart';
import 'package:e_commerce/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) {
          return OrderWidget(
            orders: ordersData.orders[i],
          );
        },
        itemCount: ordersData.orders.length,
      ),
    );
  }
}
