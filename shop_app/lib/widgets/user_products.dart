import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/products.dart';
import 'package:shopapp/screens/editing.dart';



class UserProduct extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  UserProduct({
    this.imageUrl,
    this.title
    ,this.id
});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: 100.0,
          child: Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.edit),
              onPressed: (){
                Navigator.pushNamed(context, EditingScreen.routeName,arguments:id);
              },),
              IconButton(icon: Icon(Icons.delete),
              onPressed: ()async{
                try{
                  await Provider.of<ProductsProvider>(context,listen:false).deleteItem(id);
                }catch(e){
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text("you cant delete products"),
                    )
                  );
                }
              },),
            ],
          ),
        ),
        title: Text(title),
      ),
    );
  }
}