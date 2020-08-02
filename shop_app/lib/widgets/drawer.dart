import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/auth.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/orders.dart';
import 'package:shopapp/screens/user_product_screen.dart';


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              "Hello Friend !"
            ),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            onTap: (){
              Navigator.of(context).pushReplacementNamed("/");
            },
            leading: Icon(Icons.shopping_cart),
            title: Text("Shop",style: TextStyle(color: Colors.black),),
          ),
                    ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("orders",style: TextStyle(color: Colors.black),),
            onTap: (){
              Navigator.of(context).pushNamed(OrderScreen.routename);
            },
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("your Products",style: TextStyle(color: Colors.black),),
            onTap: (){
              Navigator.of(context).pushNamed(UserProductScreen.routename);
            },
          ),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Log Out",style: TextStyle(color: Colors.black),),
              onTap: (){
                Navigator.of(context).pop();
                 Provider.of<Auth>(context,listen:false).logOutUser();
              },
            ),
        ],
          ),
      );
  }
}
