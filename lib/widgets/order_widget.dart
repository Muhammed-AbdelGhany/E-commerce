import 'dart:math';

import 'package:e_commerce/providers/orders.dart';
import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatefulWidget {
  final OrderItem orders;

  OrderWidget({this.orders});

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: _expanded
          ? min(widget.orders.products.length * 20.00 + 300, 200)
          : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.orders.amount}'),
              subtitle:
                  Text(DateFormat('dd MM yyyy').format(widget.orders.dateTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: _expanded
                  ? min(widget.orders.products.length * 20.00 + 200, 100)
                  : 0,
              padding: EdgeInsets.all(10),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10),
                children: [
                  ...widget.orders.products
                      .map(
                        (e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.title,
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              '${e.quantity}x \$${e.price}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            )
                          ],
                        ),
                      )
                      .toList()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
