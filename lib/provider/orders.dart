import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItems {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;
  OrderItems(
      {@required this.amount,
      @required this.dateTime,
      @required this.id,
      @required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItems> _orders = [];
  List<OrderItems> get orders {
    return [..._orders];
  }

  final String token;
  final String userID;
  Orders(this.token, this._orders, this.userID);
  Future<void> fetchAndSetData() async {
    final url = Uri.parse(
        'https://shop-app-ae497-default-rtdb.firebaseio.com/orders/$userID.json?auth=$token');
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItems> loadedList = [];
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((cartID, cartItem) {
      loadedList.add(OrderItems(
          amount: cartItem['amount'],
          dateTime: DateTime.parse(cartItem['dateTime']),
          id: cartID,
          products: (cartItem['products'] as List<dynamic>).map((item) {
            return CartItem(
                id: item['id'],
                price: item['price'],
                quantity: item['quantity'],
                title: item['title']);
          }).toList()));
    });
    _orders = loadedList.reversed.toList();
    notifyListeners();
  }

// we didnt handle the error here yet
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final url = Uri.parse(
        'https://shop-app-ae497-default-rtdb.firebaseio.com/orders/$userID.json?auth=$token');

    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'price': cp.price,
                    'quantity': cp.quantity,
                    'title': cp.title
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItems(
            amount: total,
            dateTime: timeStamp,
            id: json.decode(response.body)['name'],
            products: cartProducts));
    notifyListeners();
  }
}
