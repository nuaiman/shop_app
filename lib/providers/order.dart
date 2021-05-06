import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final List<CartItem> cartProds;
  final double totalAmount;
  final DateTime date;

  OrderItem(
    this.id,
    this.totalAmount,
    this.cartProds,
    this.date,
  );
}

class Order with ChangeNotifier {
  String token;
  String userId;
  Order(this.token, this.userId, this._items);

  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  Future<void> addOrder(double totalAmount, List<CartItem> cartProds) async {
    var params = {
      'auth': token,
    };

    var url = Uri.https('flutter-maxsw-shop-default-rtdb.firebaseio.com',
        '/orders/$userId.json', params);
    final nowDate = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'totalAmount': totalAmount,
          'dateTime': nowDate.toIso8601String(),
          'cartProds': cartProds
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'imageUrl': cp.imageUrl,
                    'quantity': cp.quantity,
                  })
              .toList(),
        }),
      );
      _items.insert(
        0,
        OrderItem(
          json.decode(response.body)['name'],
          totalAmount,
          cartProds,
          nowDate,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetOrder() async {
    var params = {
      'auth': token,
    };
    var url = Uri.https('flutter-maxsw-shop-default-rtdb.firebaseio.com',
        '/orders/$userId.json', params);
    try {
      final responseData = await http.get(url);
      final List<OrderItem> loadedList = [];
      final response = json.decode(responseData.body) as Map<String, dynamic>;
      response.forEach((oId, oDt) {
        loadedList.insert(
          0,
          OrderItem(
            oId,
            oDt['totalAmount'],
            (oDt['cartProds'] as List<dynamic>)
                .map(
                  (cI) => CartItem(
                    id: cI['id'],
                    title: cI['title'],
                    price: cI['price'],
                    imageUrl: cI['imageUrl'],
                    quantity: cI['quantity'],
                  ),
                )
                .toList(),
            DateTime.parse(oDt['dateTime']),
          ),
        );
      });
      _items = loadedList;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
