import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/widgets/order_item.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class Order  {

  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  Order({@required this.id,
    @required this.amount,
    @required this.dateTime,
    @required  this.products,

  });
}


class Orders with ChangeNotifier {
  final authToken;
  final userId;
  Orders(this.authToken,this.userId,this._orders);

  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }
  Future<void> fetchOrders() async{
    final url = 'https://shopapp-10706.firebaseio.com/order/$userId.json?auth=$authToken';
    final response=await http.get(url);
    final extractData=json.decode(response.body)as Map<String , dynamic>;
    if(extractData==null){
      return ;
    }
    final List<Order> loadedData=[];

     extractData.forEach((orderId, data) {
      loadedData.add(
        Order(
          id:orderId,
          amount:data['amount'],
          dateTime: DateTime.parse(data['dateTime']),
          products: (data['products']as List<dynamic>)
              .map((cp) => CartItem(
                                     id:cp['id'],
                                     price: cp['price'],
                                     quantity: cp['quantity'],
                                     title: cp['title']
                     )).toList(),
        ),
      );

    }
    );
    _orders=loadedData;
    notifyListeners();

  }

  Future<void> addOrder(List<CartItem> cartProduct, double total)async {

    final url = 'https://shopapp-10706.firebaseio.com/order/$userId.json?auth=$authToken';
    final timeStamp=DateTime.now();
    final response=await http.post(url,body: json.encode({
      'amount':total,
      'dateTime':timeStamp.toIso8601String(),
      //convert to map of product and convert to  toList because map return iterable
      'products':cartProduct.map((cp) =>
      {
        'id': cp.id,
        'title': cp.title,
        'quantity':cp.quantity,
        'price':cp.price
      }
      ).toList()
}
    ));

    _orders.insert(0, Order(
         id:     json.decode(response.body)['name'],
        amount:   total,
        products:  cartProduct,
        dateTime:    timeStamp
    ));

    notifyListeners();
  }



}


