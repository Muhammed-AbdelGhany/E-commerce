import 'dart:convert';

import 'package:e_commerce/providers/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.products,
      @required this.amount,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchData() async {
    const baseUrl =
        'https://flutter-ecommerce-1-2d485-default-rtdb.firebaseio.com/orders.json';
    try {
      final response = await http.get(baseUrl);
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> recentOrders = [];
      loadedData.forEach((orderId, orderData) {
        recentOrders.add(OrderItem(
            id: orderId,
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price']))
                .toList(),
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime'])));
      });
      _orders = recentOrders;
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const baseUrl =
        'https://flutter-ecommerce-1-2d485-default-rtdb.firebaseio.com/orders.json';
    final currentTime = DateTime.now();
    try {
      final response = await http.post(baseUrl,
          body: json.encode({
            'amount': total,
            'dateTime': currentTime.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price
                    })
                .toList()
          }));
      _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)['name'],
            products: cartProducts,
            amount: total,
            dateTime: currentTime,
          ));
      notifyListeners();
    } catch (error) {}
  }
}
