import 'package:flutter/material.dart';
import 'package:shopapp/provider/products.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'file:///C:/Users/shark/Documents/mobile%20development/shop_app/lib/provider/product.dart';
import 'package:shopapp/widgets/product_item.dart';
import 'package:shopapp/widgets/products_overview.dart';
import 'package:provider/provider.dart';
import '../widgets/badge.dart';
import '../widgets/drawer.dart';
import '../provider/cart.dart';
enum Filter{
  Favourite,
  All
}
class ProductsOverView extends StatefulWidget {
  static const String routeName="/overview_screen";
  @override
  _ProductsOverViewState createState() => _ProductsOverViewState();
}

class _ProductsOverViewState extends State<ProductsOverView> {
  bool isFavourite=false;
  bool isInit=true;
  bool spining=false;
  @override

  @override
  void didChangeDependencies()  {
    super.didChangeDependencies();
    if(isInit){
       setState(() {
         spining=true;
       });
      Provider.of<ProductsProvider>(context).fetchAndGetData().then((_) {
        setState(() {
          spining=false;
        });
      });
    }
    isInit=false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
        brightness: Brightness.light,
        backgroundColor: Colors.purple,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (Filter selectedValue){
              setState(() {
                if(selectedValue==Filter.Favourite){
                      isFavourite=true;
                }
                else{
                      isFavourite=false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (c){
              return [
                PopupMenuItem(
                  value:Filter.Favourite ,
                  child: Text("favourite Items"),
                ),
                PopupMenuItem(
                  value:Filter.All ,
                  child: Text("All Options"),
                ),
              ];
            },
          ),
          Consumer<CartProvider>(
            builder: (_,cartt,ch) => Badge(
              child:ch ,
              value:cartt.returnCount.toString(),
            ),
            child:IconButton(
              icon:Icon(Icons.shopping_cart),
              onPressed: (){
                Navigator.pushNamed(context,CartScreen.nameRoute);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body:spining?Center(child: CircularProgressIndicator()): Container(
          padding:EdgeInsets.all(10.0) ,
          child: ProductsOverview(isFavourite)),
    );
  }
}