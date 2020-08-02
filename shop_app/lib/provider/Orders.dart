import 'dart:convert';

import 'package:flutter/material.dart';
import 'cart.dart';
import 'package:http/http.dart' as http;

class OrderItem{
  final String id;
  final double total;
  final List<Cart> cartList;
  DateTime dateTime;

  OrderItem({
  @required this.id,
  @required this.total,
  @required this.dateTime,
  @required this.cartList

});
}

class OrdersProvider with ChangeNotifier{
  final token;
  OrdersProvider(this.token,this.cart,this._userId);
  List <OrderItem> cart=[];
  final String _userId;
  List <OrderItem> get getOrder{
    return [...cart];
  }
  // وانت بتكتب اي فانكشن ارزع notifyListeners()

  Future<void> fetchAndSetData() async{
    final url = "https://shop-app-ee84c.firebaseio.com/orders/$_userId.json?auth=$token";
    http.Response response= await http.get(url);
    var extracteddata=json.decode(response.body) as Map<String,dynamic>;
    if(extracteddata==null){
      return;
    }
    else{
      List<OrderItem> loadedOrdersItem=[];
      extracteddata.forEach((prodId,proddata){
        loadedOrdersItem.add(
            OrderItem(
                id: prodId,
                total: proddata["amount"],
                dateTime: DateTime.parse(proddata["datetime"]),
                cartList: (proddata["products"] as List<dynamic>).map((e)
                =>Cart(
                titile:e["title"] ,
                 quantity: e["quantity"],
                price: e["price"],
                id: e["id"]
            )
                ).toList()
            )
        );
      });
      cart= loadedOrdersItem;
      notifyListeners();
    }
      }
  Future<void> addOrders(double total,List<Cart> items)async{
    final url = "https://shop-app-ee84c.firebaseio.com/orders/$_userId.json?auth=$token";
    var time=DateTime.now();
    http.Response response=await http.post(url,body: json.encode({
     "amount" :  total,
     "datetime":time.toIso8601String(),
      "products": items.map((e) =>
       {
         "id":time.toIso8601String(),
         "quantity":e.quantity,
         "title":e.titile,
         "price":e.price
       }
      ).toList()
    }));
    cart.insert(0, OrderItem(
        id:jsonDecode(response.body)["name"],
        total:total,
        dateTime: DateTime.now(),
        cartList: items)
    );
    notifyListeners();
  }
}