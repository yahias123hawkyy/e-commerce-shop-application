import 'product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

final url = "https://shop-app-ee84c.firebaseio.com/products.json";

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2,',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  var token;
ProductsProvider(this.token,this.userId,this._items);
  List<Product> get itemsList {
//    if (isFavouriteNeeded) {
//      return _items.where((prod) => prod.isFavourite == true).toList();
//    } else {
    return [..._items];
  }

  Product findbyId(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addItems() {
//    _items.add(value)
    notifyListeners();
  }

  var isFavouriteNeeded = false;
  final String userId;
  List<Product> favouriteGeter() {
    return _items.where((prod) => prod.isFavourite).toList();
  }
  Future <void> fetchAndGetData ([bool filtered= false]) async {
    String filterString= filtered ? "&orderBy='creatorId'&equalTo=$userId":"";
    var url = "https://shop-app-ee84c.firebaseio.com/products.json?auth=$token";
    try {
      http.Response response = await http.get(url);
      List<Product> products = [];
      var extractedData = jsonDecode(response.body) as Map<String, dynamic>;
       url="https://shop-app-ee84c.firebaseio.com/userfavourites/$userId.json?auth=$token$filterString";
       final favouriteResponse=await http.get(url);
       final extracteddataFav=json.decode(favouriteResponse.body);
       extractedData.forEach((prodId, data) {
        Product product = Product(
            id: prodId,
            title: data["title"],
            imageUrl: data["imgUrl"],
            price: data["price"],
            description: data["description"],
            isFavourite: extracteddataFav == null ? false: extracteddataFav[prodId]?? false
        );
        products.add(product);
        _items = products;
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }
  Future<void> addProducts(Product product) async {
    final url = "https://shop-app-ee84c.firebaseio.com/products.json?auth=$token";
    try {
      http.Response response = await http.post(url,
          body: json.encode({
            "title": product.title,
            "price": product.price,
            "description": product.description,
            "isFav": product.isFavourite,
            "imgUrl": product.imageUrl,
            "creatorId":userId,
          }));
      final Product productItem = Product(
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          title: product.title,
          id: jsonDecode(response.body)["name"]);
      _items.add(productItem) ;
      notifyListeners();
    } catch (e) {
      print(e);
      throw (e);
    }
  }
  void updateItems(String id, Product product) async {
    final String url2 =
        "https://shop-app-ee84c.firebaseio.com/products/$id.json?auth=$token";
    final existedItemIndex = _items.indexWhere((element) => element.id == id);
    if (existedItemIndex >= 0) {
      await http.patch(url2,
          body: json.encode({
            "title": product.title,
            "price": product.price,
            "description": product.description,
            "imgUrl": product.imageUrl,
          }));
      _items[existedItemIndex] = product;
      notifyListeners();
    }
  }
  Future <void>  deleteItem(String id) async {
    final String url2 = "https://shop-app-ee84c.firebaseio.com/products/$id.json?auth=$token";
       final existingProductIndex=_items.indexWhere((element) => element.id==id);
       var existingProduct=_items[existingProductIndex];
       _items.remove(existingProduct);
        final http.Response response=await http.delete(url2);
         if(response.statusCode >= 400) {
           _items.insert(existingProductIndex, existingProduct);
           notifyListeners();
           throw HttpException("could not load product");
         }
        _items.removeAt(existingProductIndex);
  }
}