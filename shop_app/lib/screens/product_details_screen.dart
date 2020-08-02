import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';


class ProductDetailScreen extends StatelessWidget {
  static const String nameRoute="/Product_Screen";

  @override
  Widget build(BuildContext context) {
    var productId=ModalRoute.of(context).settings.arguments as String;
    var item=Provider.of<ProductsProvider>(context,listen: false).findbyId(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: SingleChildScrollView(
          child: Column(
             children: <Widget>[
               Container(
                child: Image.network(item.imageUrl),
                width: double.infinity,
                height:300.0,
               ),
               Container(
                 alignment: Alignment.center,
                 child:Text(
                   "${item.price} \$",
                    style: TextStyle(
                      fontSize: 30.0
                    ),
                 ) ,
               ),
               SizedBox(
                 height: 10.0,
               ),
               Text(
                 item.description
               )
             ],
          )),
    );
  }
}
