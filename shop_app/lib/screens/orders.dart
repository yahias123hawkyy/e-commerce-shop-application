import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/Orders.dart';
import 'package:shopapp/widgets/order_widget.dart';


class OrderScreen extends StatefulWidget {

  static const String routename="orders_screen";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {


//    final orderProvider= Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
       title:Text("your items")
    ),
      body:FutureBuilder(
        future:Provider.of<OrdersProvider>(context,listen: false).fetchAndSetData() ,
        builder: (ctx,dataSnapshot){
          if(dataSnapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else{
            if(dataSnapshot.error!=null){
              print(dataSnapshot.error);
             return Text("someThing happened");
            }
            else{
                   return Consumer<OrdersProvider>(builder:(ctx,order,child){
                     print("shit");
                     return ListView.builder(itemBuilder:(ctx,i){
                        return OrderWidget(
                            order.cart[i]
                        );
                      },
                        itemCount: order.cart.length,
                      );
                    },
                    );
            }
          }
        },
      )

    );
    }
}
