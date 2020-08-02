import"package:flutter/foundation.dart";


class Cart{
  String id;
  String titile;
  int quantity;
  double price;

  Cart({
  @required this.id,
  @required this.titile,
  @required this.price,
  @required  this.quantity
});
}

class CartProvider with ChangeNotifier {

  Map <String, Cart> _items = {};

  Map<String, Cart> get list {
    return {..._items};
  }

  void addCart(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (existingItem) =>
          Cart(
              id: existingItem.id,
              price: existingItem.price,
              titile: existingItem.titile,
              quantity: existingItem.quantity + 1
          ));
    }
    else {
      _items.putIfAbsent(productId, () =>
          Cart(
              titile: title,
              price: price,
              quantity: 1,
              id: productId
          ));
    }
    notifyListeners();
  }

  int get returnCount {
    return _items.length;
  }

  double gettotalAmount() {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void deleteItem(prodId){
    _items.remove(prodId);
    notifyListeners();
  }
  void clear(){
    _items={};
  }

  void stopOperation(String prodId){
    if(!_items.containsKey(prodId)) {
        return ;
    }
      if(_items.length >1){
        _items.update(prodId, (value) => Cart(
            id:prodId ,
            titile:value.titile ,
            price: value.price,
            quantity:value.quantity -1 ));
      }
      else{
        _items.remove(prodId);
      }
    }

    notifyListeners();
  }



