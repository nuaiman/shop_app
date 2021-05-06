import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFav;

  Product({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.description,
    @required this.imageUrl,
    this.isFav = false,
  });

  Future<void> toggleFavStatus(String token, String userId) async {
    var params = {
      'auth': token,
    };
    var url = Uri.https('flutter-maxsw-shop-default-rtdb.firebaseio.com',
        '/userFavs/$userId/$id.json', params);
    var favStatus = isFav;
    isFav = !isFav;
    notifyListeners();
    final response = await http.put(
      url,
      body: json.encode(
        isFav,
      ),
    );
    if (response.statusCode >= 400) {
      isFav = favStatus;
      notifyListeners();
    }
  }
}

class Products with ChangeNotifier {
  String token;
  String userId;
  Products(this.token, this.userId, this._items);

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFav).toList();
  }

  Product searchById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) async {
    var params = {
      'auth': token,
    };
    var url = Uri.https('flutter-maxsw-shop-default-rtdb.firebaseio.com',
        '/products.json', params);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'cId': userId,
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
        }),
      );
      final responseData = json.decode(response.body);
      final newProduct = Product(
        id: responseData['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        isFav: product.isFav,
      );
      _items.insert(0, newProduct);
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    var _params;
    if (filterByUser) {
      _params = <String, String>{
        'auth': token,
        'orderBy': json.encode('cId'),
        'equalTo': json.encode(userId),
      };
    }
    if (filterByUser == false) {
      _params = <String, String>{
        'auth': token,
      };
    }
    var url = Uri.https('flutter-maxsw-shop-default-rtdb.firebaseio.com',
        '/products.json', _params);
    try {
      final responseData = await http.get(url);
      final response = json.decode(responseData.body) as Map<String, dynamic>;

      url = Uri.https('flutter-maxsw-shop-default-rtdb.firebaseio.com',
          '/userFavs/$userId.json', _params);

      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);

      final List<Product> loadedList = [];
      response.forEach((pId, pDt) {
        loadedList.insert(
          0,
          Product(
            id: pId,
            title: pDt['title'],
            price: pDt['price'],
            description: pDt['description'],
            imageUrl: pDt['imageUrl'],
            isFav: favData == null ? false : favData[pId] ?? false,
          ),
        );
      });
      _items = loadedList;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    var params = {
      'auth': token,
    };
    final prodIndex = _items.indexWhere((element) => element.id == id);
    var url = Uri.https('flutter-maxsw-shop-default-rtdb.firebaseio.com',
        '/products/$id.json', params);
    try {
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'price': newProduct.price,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'isFav': newProduct.isFav,
        }),
      );

      _items[prodIndex] = newProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    var params = {
      'auth': token,
    };
    var url = Uri.https('flutter-maxsw-shop-default-rtdb.firebaseio.com',
        '/products/$id.json', params);
    final productIndex = _items.indexWhere((element) => element.id == id);
    var product = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, product);
      notifyListeners();
    }
    product = null;
  }
}
