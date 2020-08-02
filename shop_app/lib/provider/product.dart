import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart'  as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;
  Product({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.description,
    @required this.imageUrl,
    this.isFavourite
});

  returnDefault(oldStatus){
      isFavourite=oldStatus;
  }

  void checkFavourite(String token,String userId)async{
    final String url="https://shop-app-ee84c.firebaseio.com/userfavourites/$userId/$id.json?auth=$token";
    bool oldStatus=isFavourite;
    isFavourite=!isFavourite;
    try{
      http.Response response= await http.put(url,body:json.encode(
        isFavourite
      ));
      notifyListeners();
      if(response.statusCode>=400){
        returnDefault(oldStatus);
      }
    }catch(_){
      returnDefault(oldStatus);
    }
  }
}