import 'package:flutter/material.dart';
import 'package:shopapp/provider/products.dart';
import 'package:shopapp/widgets/product_item.dart';
import 'package:provider/provider.dart';
class ProductsOverview extends StatelessWidget {
  final bool isfavourite;
  ProductsOverview(this.isfavourite);
  @override
  Widget build(BuildContext context) {
   final productsdata=Provider.of<ProductsProvider>(context);
   final products=isfavourite?productsdata.favouriteGeter() :  productsdata.itemsList;
    return GridView.builder(itemCount:products.length,
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3/2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0
        ),
        itemBuilder:(ctx, i) => ChangeNotifierProvider.value(
          value:  products[i],
          child: ProductItem(),
        )
    );
  }
}
