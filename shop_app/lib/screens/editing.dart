import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/product.dart';
import 'package:shopapp/provider/products.dart';



class EditingScreen extends StatefulWidget {
  static const String routeName="editing_screen";
  @override
  _EditingScreenState createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {

  bool checkProgress=false;

  var initialValues={
    "title":"",
    "price":"",
    "description":"",
    "imgUrl":""
  };
  var productExsisting=Product(
     id: null,
     price: 0,
     title: "",
    description: "",
    imageUrl: "",
  );

  final _focusNode=FocusNode();
  final _focusNode2=FocusNode();
  var controller=TextEditingController();
  final _desNode2 =FocusNode();
  final imageUrl=FocusNode();
  bool _isInit=true;
  GlobalKey <FormState> form =GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    imageUrl.addListener(updateImg);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_isInit){
      final prodId=ModalRoute.of(context).settings.arguments;
      print("$prodId hee");
      if(prodId!=null){
        productExsisting =Provider.of<ProductsProvider>(context,listen: false).findbyId(prodId);
        initialValues={
          "title":productExsisting.title,
          "price":productExsisting.price.toString(),
          "description":productExsisting.description,
         "imgUrl":""
        };
        controller.text=productExsisting.imageUrl;
      }
      _isInit=false;
    }
  }
  void updateImg(){
    if(!imageUrl.hasFocus) {
      setState(() {});
    }
  }
  Future <void> saveForm() async {
     final bool  isVal=form.currentState.validate();
     if(!isVal)
     {
     return;
     }
     form.currentState.save();
     if(productExsisting.id!=null){
       Provider.of<ProductsProvider>
         (context,listen:false).updateItems(productExsisting.id,productExsisting);
     }
     else{
       try {
         setState(() {
           checkProgress=true;
          });
          await Provider.of<ProductsProvider>(context, listen: false)
             .addProducts(productExsisting);
       }catch(e){
          showDialog(context: context,builder: (context){
           return AlertDialog(
             title: Text("someething bad happened mann!!"),
             actions: <Widget>[
               FlatButton(child: Text("ok"),onPressed: (){
                 Navigator.of(context).pop();
               },),
             ],

           );
         });
       }
     }
     setState(() {
       checkProgress=false;
     });
     Navigator.pop(context);
  }
  void dispose() {
    _focusNode2.dispose();
    _focusNode.dispose();
     controller.dispose();
    _desNode2.dispose();
    imageUrl.dispose();
    super.dispose();
  }
  String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add your Items!!")
      ,actions: <Widget>[
        IconButton(
          icon: Icon(Icons.save),
          onPressed: (){
            saveForm();
          },
        )
        ],),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: form,
          child: ListView(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius:BorderRadius.circular(20.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    initialValue: initialValues["title"],
                     validator: (value){
                       if(value.isEmpty){
                         return "you should write a title";
                       }
                       else{
                         return null;
                       }
                     },
                    onSaved: (val){
                      productExsisting=Product(
                       id: productExsisting.id,
                       isFavourite: productExsisting.isFavourite,
                       title: val,
                       imageUrl:productExsisting.imageUrl,
                       price: productExsisting.price,
                       description: productExsisting.description
                      );
                    },
                    onFieldSubmitted:(val)=>FocusScope.of(context).requestFocus(_focusNode2) ,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Title",
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _focusNode,
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius:BorderRadius.circular(20.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    initialValue: initialValues["price"],
                      validator: (value){
                       if(value.isEmpty){
                     return "you should write a price";
    }
                  else if(double.tryParse(value)==null || double.parse(value) <= 0){
                     return "please,enter a valid number";
    }
                  else{
                     return null;
    }
    },
                    onSaved: (val){
                      productExsisting=Product(
                          id: productExsisting.id,
                          isFavourite: productExsisting.isFavourite,
                          title: productExsisting.title,
                          imageUrl:productExsisting.imageUrl,
                          price: double.parse(val),
                          description: productExsisting.description
                      );
                    },
                    onFieldSubmitted:(val)=>FocusScope.of(context).requestFocus(_desNode2) ,
                    focusNode:_focusNode2 ,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Price",
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
              SizedBox(height:10.0,),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius:BorderRadius.circular(20.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    initialValue: initialValues["description"],
                    validator: (value){
                      if(value.isEmpty){
                        return "you should write a description";
                      }
                      else if(value.length<=20){
                        return "enter a description that at least 20 characters";
                      }
                      return null;
                },
                    onSaved: (val){
                      productExsisting=Product(
                          id: productExsisting.id,
                          isFavourite: productExsisting.isFavourite,
                          title: productExsisting.title,
                          imageUrl:productExsisting.imageUrl,
                          price:productExsisting.price,
                          description: val
                      );
                    },
                    maxLines: 3,
                    onFieldSubmitted:(val)=>FocusScope.of(context).requestFocus(imageUrl) ,
                    focusNode:_desNode2 ,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Description",
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 100.0,
                    width: 100.0,
                    decoration:  BoxDecoration(
                       border: Border.all(
                         color: Colors.black
                       ),
//                      border:,
                    ),
                    child:controller.text.isEmpty?Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text("put the url,please")),
                    ):
                        FittedBox(
                        fit: BoxFit.cover,
                          child: Image.network(controller.text),
                        )
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:BorderRadius.circular(20.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
//                          initialValue: initialValues["description"],
                          validator: (value){
//                            if(value.isEmpty){
//                              return "you should write a ";
//                            }
//                            else if(value.startsWith("http") && value.endsWith(".com")){
//                              return"valid please";
//                            }
                            return null;
                          },
                          onSaved: (val){
                            productExsisting=Product(
                                id: productExsisting.id,
                                isFavourite: productExsisting.isFavourite,
                                title: productExsisting.title,
                                imageUrl:val,
                                price:productExsisting.price ,
                                description:productExsisting.description
                            );
                          },
                          onFieldSubmitted:(_){ saveForm();},
                          focusNode: imageUrl,
                          textInputAction: TextInputAction.done,
                          keyboardType:TextInputType.url ,
                          controller: controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Image Url",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}