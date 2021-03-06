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
  final token;
  final userId;

  Orders(this.token, this.userId, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchData() async {
    final baseUrl =
        'https://flutter-ecommerce-1-2d485-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    try {
      final response = await http.get(baseUrl);
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      if (loadedData == null) {
        return;
      }
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
    final baseUrl =
        'https://flutter-ecommerce-1-2d485-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
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
