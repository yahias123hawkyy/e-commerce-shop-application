import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/products.dart';
import '../widgets/user_products.dart';
import 'editing.dart';
import '../widgets/drawer.dart';

class UserProductScreen extends StatelessWidget {
  static const String routename = "user_screen";


  Future <void> refresh(BuildContext ctx) async{
      await Provider.of<ProductsProvider>(ctx,listen: false).fetchAndGetData(true);
    }
  @override
  Widget build(BuildContext context) {
//    final product = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditingScreen.routeName);
                },
                icon: Icon(
                  Icons.add,
                  size: 27.0,
                ),
              ))
        ],
      ),
      body: FutureBuilder(
        future: refresh(context),
        builder: (ctx,snapshot)=>Consumer<ProductsProvider>(
          builder: (ctx,product,_)=>RefreshIndicator(
            onRefresh: ()=>refresh(context),
            child:snapshot.connectionState==ConnectionState.waiting?
            Center(
                child:
            CircularProgressIndicator())
                : Container(
              child: ListView.builder(
                  itemCount: product.itemsList.length,
                  itemBuilder: (ctx, i) => UserProduct(
                    id: product.itemsList[i].id,
                    title: product.itemsList[i].title,
                    imageUrl: product.itemsList[i].imageUrl,
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }
}
