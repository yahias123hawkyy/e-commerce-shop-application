import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:shopapp/provider/Orders.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/editing.dart';
import 'package:shopapp/screens/orders.dart';
import 'package:shopapp/screens/user_product_screen.dart';
import 'package:shopapp/widgets/splash.dart';
import 'provider/products.dart';
import 'screens/products_overview_screen.dart';
import 'screens/product_details_screen.dart';
import 'provider/cart.dart';
import 'screens/cart_screen.dart';
import 'provider/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: Auth()),
        ChangeNotifierProxyProvider<Auth,ProductsProvider>(
          update:(ctx,auth,p)=> ProductsProvider(auth.getToken,auth.getUserid,p==null?[]:p.itemsList),
        ),
        ChangeNotifierProvider.value(
          value: CartProvider(),
        ),
        ChangeNotifierProxyProvider<Auth,OrdersProvider>(
            update:(ctx,auth,previous)=>OrdersProvider(auth.getToken,previous==null?[]:previous.getOrder,auth.userId))
      ],
      child:Consumer<Auth>(
        builder: (ctx,provider,_)=> MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
              textTheme: TextTheme(
                  bodyText1: TextStyle(
                      color: Colors.white
                  )
              ),
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'
          ),
          home:provider.isAuth?ProductsOverView(): FutureBuilder(future:provider.tryAutoLogin(),builder:(ctx,snapshot) =>snapshot.connectionState==ConnectionState.waiting? Splash() :AuthScreen()),
          routes: {
            ProductsOverView.routeName:(ctx)=>ProductsOverView(),
            ProductDetailScreen.nameRoute:(ctx) => ProductDetailScreen(),
            CartScreen.nameRoute:(ctx) => CartScreen(),
            OrderScreen.routename:(ctx) => OrderScreen(),
            UserProductScreen.routename:(ctx)=>UserProductScreen(),
            EditingScreen.routeName:(c)=>EditingScreen()
          },
        ),
      ),
    );
  }
}
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: FlatButton(
          child: Text("press"),
            onPressed: (){
            Navigator.push(context,MaterialPageRoute(
              builder: (ctx){
                return ProductsOverView();
              }
            ));
            },
        ),
      ),
    );
  }
}
