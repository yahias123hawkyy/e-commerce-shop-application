import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
class Auth with ChangeNotifier{
  String _token;
  DateTime expiryDate;
  String userId;
  var authTime;

bool get isAuth{
  return _token!=null;
}
  String get getToken{
    if(  _token!=null && expiryDate!=null){
      return _token;
    }
    return null;
  }

  String get getUserid{
  return userId;
  }
  Future<void>_authenticate(String email,String password,String urlSegment)async{
     String
    url="https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBOd1HvPAw4mM0yKLopPLbRfpL618zahVM";
     try{
     final response= await http.post(
         url,body: json.encode({
       "email":email,
       "password":password,
       "returnSecureToken":true
     }));
     var extractedData=json.decode(response.body);
     _token=extractedData["idToken"];
     expiryDate=DateTime.now().add(Duration(seconds:int.parse(extractedData["expiresIn"])));
     userId=extractedData["localId"];
     autoLogout();
     notifyListeners();
     var userData=json.encode({
       "token":_token,
       "expiryDate":expiryDate.toIso8601String(),
       "userId":userId
     });
   final pref= await SharedPreferences.getInstance();
   pref.setString("userData", userData);

   }catch(error){
       throw HttpException(error);
   }
  }
  Future <void> signup(String email,String password) async  {
    return _authenticate(email,password,"signUp");
  }
  Future<void> logIn(String email,String password) async{
   return _authenticate(email,password,"signInWithPassword");
  }

  Future<bool> tryAutoLogin() async {
   final pref= await SharedPreferences.getInstance();
   if(!pref.containsKey("userData")){
     return false;
   }
  final extractedUserData=json.decode(pref.getString("userData")) as Map<String,dynamic>;
  var expirydate=DateTime.parse(extractedUserData["expiryDate"])     ;
  
  if(expirydate.isAfter(DateTime.now())){
    return false;
  }

  _token=extractedUserData["token"];
  userId =extractedUserData["userId"];
  expiryDate=expirydate;
  autoLogout();

  notifyListeners();

  return true;

  }
  void logOutUser(){
    _token=null;
    expiryDate=null;
    userId=null;
    if(authTime!=null){
      authTime.cancel();
      authTime=null;
    }
    notifyListeners();
  }
 void autoLogout(){

  if(authTime != null){
    authTime.cancel();
  }

 var differenceInTime= expiryDate.difference(DateTime.now()).inSeconds;
  authTime=Timer(Duration(seconds:differenceInTime ),logOutUser);
 }
}