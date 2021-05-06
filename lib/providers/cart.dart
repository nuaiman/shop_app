import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  int quantity;
  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.imageUrl,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get totalCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((pId, cartData) {
      total += cartData.price * cartData.quantity;
    });
    return total;
  }

  void increaeQty(String pId) {
    _items.update(
      pId,
      (value) => CartItem(
          id: value.id,
          title: value.title,
          price: value.price,
          imageUrl: value.imageUrl,
          quantity: value.quantity + 1),
    );
    notifyListeners();
  }

  void decreaseQuantity(String pId) {
    if (_items[pId].quantity == 1) {
      return;
    } else {
      _items.update(
        pId,
        (value) => CartItem(
            id: value.id,
            title: value.title,
            price: value.price,
            imageUrl: value.imageUrl,
            quantity: value.quantity - 1),
      );
    }
    notifyListeners();
  }

  void addToCart(String pId, String title, double price, String imageUrl) {
    if (_items.containsKey(pId)) {
      _items.update(
        pId,
        (value) => CartItem(
            id: value.id,
            title: value.title,
            price: value.price,
            imageUrl: value.imageUrl,
            quantity: value.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        pId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            imageUrl: imageUrl,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String pId) {
    if (!_items.containsKey(pId)) {
      return;
    }
    if (_items[pId].quantity > 1) {
      _items.update(
        pId,
        (value) => CartItem(
            id: value.id,
            title: value.title,
            price: value.price,
            imageUrl: value.imageUrl,
            quantity: value.quantity - 1),
      );
    } else {
      _items.remove(pId);
    }
    notifyListeners();
  }
}
