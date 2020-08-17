import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier{

  String _token;
  DateTime _expireToken;
  String _userId;

  bool get isAuth {
  return token!=null;
}
  String  get  token{
  if(_expireToken!=null&&
      _expireToken.isAfter(DateTime.now())&&
      _token!=null){
    return _token;}
   return null;}
  String  get userId{
    return _userId;
  }





  Future<void> authenticate(String email,String password,String segment) async{
    final url="https://identitytoolkit.googleapis.com/v1/accounts:$segment?key=AIzaSyAioisoIhoUJ67jrKJFG40xx-4IQTzRmCk";

  try {
  final response = await http.post(
  url,
  body: json.encode(
  {
  'email': email,
  'password': password,
  'returnSecureToken': true,
  },
  ),
  );

  final responseData = json.decode(response.body);


  if (responseData['error'] != null) {
  throw HttpExecption(responseData['error']['message']);

  }
  _token=responseData['idToken'];
  _expireToken=DateTime.now().add(Duration(seconds:int.parse(responseData['expiresIn'])));
  _userId=responseData['localId'];
  notifyListeners();
  } catch (error) {
  throw error;
  }
}

  Future<void> signUp(String email, String password) async {
  return authenticate(email, password, 'signUp');
}

  Future<void> logIn(String email, String password) async {
  return authenticate(email, password, 'signInWithPassword');
}


}