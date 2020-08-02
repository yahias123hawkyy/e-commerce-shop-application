import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/cart.dart';


class CartItem extends StatelessWidget {
  final double price;
  final String title;
  final double quantity;
  final String id;
  CartItem({
    this.price,
    this.quantity,
    this.title,
    this.id
});
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context);
    return Dismissible(
      confirmDismiss:(direction){
       return showDialog(context: context  ,builder: (ctx){
          return AlertDialog(
          title:Text("Are you sure?") ,
            content: Text("this Item will be deleted from the cart."),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: (){
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
      },
      onDismissed:(dir)=> cart.deleteItem(id),
      direction:DismissDirection.endToStart ,
      key:ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.delete,size: 40.0,color: Colors.white,),
        ),
      ),
      child: Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: CircleAvatar(
                child: FittedBox(child: Text(
                   "$price\$"
                    )),
              ),
              title: Text(title),
              subtitle: Text((price*quantity).toString()),
              trailing: Text("${quantity.toInt()} x"),
            ),
          )
      ),
    );
  }
}