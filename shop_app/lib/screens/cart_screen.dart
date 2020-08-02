import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/Orders.dart';
import 'package:shopapp/provider/cart.dart';
import 'package:shopapp/screens/orders.dart';
import '../widgets/cart_item.dart';


class CartScreen extends StatelessWidget {
  static const nameRoute="cart_screen ";
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context);
    final cart2=Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:Text ("Shop"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total :",style: TextStyle(
                    fontSize: 20.0
                  ),),
                 Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text("${cart.gettotalAmount().toString()}  \$",style:
                       Theme.of(context).textTheme.bodyText1
                    ,),
                  ),
                  Button(cart2: cart2, cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0,)
          ,Expanded(
            child:ListView.builder(
                itemCount: cart.list.length,itemBuilder: (ctx,i){
             return CartItem(
               title:cart.list.values.toList()[i].titile,
               price: cart.list.values.toList()[i].price,
               id: cart.list.values.toList()[i].id,
               quantity: cart.list.values.toList()[i].quantity.toDouble(),
             ) ;
            }) ,
          )
        ],
      ),
    );
  }
}

class Button extends StatefulWidget {
  const Button({
    Key key,
    @required this.cart2,
    @required this.cart,
  }) : super(key: key);

  final OrdersProvider cart2;
  final CartProvider cart;

  @override
  _ButtonState createState() => _ButtonState();
}
class _ButtonState extends State<Button> {
  bool isLosading=false;
  @override
  Widget build(BuildContext context) {
    return isLosading?CircularProgressIndicator():FlatButton(
      child: Text(
      "ORDER NOW",style:TextStyle(color:Theme.of(context).primaryColor),
      ),
      onPressed:(widget.cart.gettotalAmount()<=0 || isLosading)? null: () async{
        setState(() {
          isLosading=true;
        });
        await  widget.cart2.addOrders(
            widget.cart.gettotalAmount()
            ,widget.cart.list.values.toList() );
        await widget.cart.clear();
        setState(() {
          isLosading=false;
        });
      },
    );
  }
}
