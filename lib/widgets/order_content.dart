import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/order.dart';

class OrderContent extends StatefulWidget {
  final OrderItem ord;
  OrderContent(this.ord);

  @override
  _OrderContentState createState() => _OrderContentState();
}

class _OrderContentState extends State<OrderContent> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              DateFormat.yMEd().format(widget.ord.date),
            ),
            subtitle: Text('\$ ${widget.ord.totalAmount.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: _isExpanded
                  ? Icon(Icons.arrow_drop_up)
                  : Icon(Icons.arrow_drop_down),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Container(
              height: min(
                widget.ord.cartProds.length * 20.0 + 100,
                180,
              ),
              child: ListView(
                children: widget.ord.cartProds
                    .map(
                      (item) => Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              item.imageUrl,
                            ),
                          ),
                          title: Text(item.title),
                          subtitle: Text(
                            '${item.quantity} X \$ ${item.price.toStringAsFixed(2)}',
                          ),
                          trailing: Text(
                              '\$ ${(item.price * item.quantity).toStringAsFixed(2)}'),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
