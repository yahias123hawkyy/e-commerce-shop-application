import 'package:flutter/material.dart';
import 'package:shopapp/provider/auth.dart';
import 'package:shopapp/provider/cart.dart';
import 'package:shopapp/screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';

class ProductItem extends StatelessWidget {
//  final String image;
//  final title;
//  final String id;
//  ProductItem({this.image,this.title,this.id});
  @override
  Widget build(BuildContext context) {

    final product=Provider.of<Product>(context,listen: false);
    final product2=Provider.of<CartProvider>(context);
    final authorizedToken=Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: GridTile(
        child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context,ProductDetailScreen.nameRoute,arguments:product.id);
        },child: Image.network(product.imageUrl,fit: BoxFit.cover,)),
        footer: GridTileBar(
          title: Center(child: FittedBox(child: Text(product.title))),
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx,product,_)=> IconButton(
                icon: Icon(product.isFavourite?
                Icons.favorite
                    :Icons.favorite_border)
                ,color: Theme.of(context).accentColor
                ,onPressed:()=>product.checkFavourite(authorizedToken.getToken,authorizedToken.getUserid)
            ),
          ),
            trailing:IconButton(
                icon: Icon(
                    Icons.shopping_cart
                ,color: Theme.of(context).accentColor),
                    onPressed:() {
                      product2.addCart(product.id, product.title, product.price);
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Added to cart"),
                          action: SnackBarAction(
                             label: "UNDO",
                            onPressed: (){
                               product2.stopOperation(product.id);
                            },
                          ),
                        )
                      );
                    },
            ),
      )),
    );
  }
}
