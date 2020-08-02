import 'package:flutter/material.dart';
import '../provider/Orders.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderWidget extends StatefulWidget {
  final OrderItem item;
  OrderWidget(this.item);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool isExpanded=false;
  @override
  Widget build(BuildContext context) {
    return  Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title:Text("${widget.item.total}") ,
            subtitle:Text(DateFormat("dd MM yyyy hh:mm").format(widget.item.dateTime)) ,
            trailing: IconButton(
              icon: Icon(isExpanded?Icons.arrow_drop_up:Icons.arrow_drop_down,
              size: 30.0,),
              onPressed: (){
                setState(() {
                  isExpanded=!isExpanded;
                });
              },
            ),
          ),
          if (isExpanded) Container(
            height: min((widget.item.cartList.length.toDouble()*10+50),180),
            child: ListView(
              children:widget.item.cartList.map((e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(e.titile,style: TextStyle(
                    fontSize: 26.0
                  ),),
                  Text("${e.quantity} x",style: TextStyle(
                    fontSize: 26.0
                  ),)
                ],
              )).toList()
            ),
          )

        ],
      ),
    );
  }
}
