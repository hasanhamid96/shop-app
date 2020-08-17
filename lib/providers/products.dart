import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {


  final String authToken;
  final String userId;
  Products(this.authToken,this.userId,this._items);

  List<Product> _items = [//
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ), Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];


  List<Product> get items {
    //return a copy of array
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get isFav {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }



  Future<void> addProduct(Product product) async {
    final url = 'https://shopapp-10706.firebaseio.com/products.json?auth=$authToken';

try{
  final response=await http.post(url, body: jsonEncode({
    'title': product.title,
    'price': product.price,
    'description': product.description,
    'imageUrl': product.imageUrl,
    'created':userId

  }));
  var uniqueId=json.decode(response.body);
  var addNewProduct = Product(
      id: uniqueId['name'],
      title: product.title,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl
  );

  _items.add(addNewProduct);
  notifyListeners();
}
catch(error){
  throw error;
}

  }



  Future<void> fetchtheProducts([bool fetchUser=false]) async {
    final filterString =fetchUser?'orderBy="created"&equalTo="$userId"':'';
    var url = 'https://shopapp-10706.firebaseio.com/products.json?auth=$authToken&$filterString';
    try{
      final response=await http.get(url);
      final    extractData=json.decode(response.body) as Map< String , dynamic>;
      //map inside map dart will not able to know for that we use dynamic

      if(extractData==null){
        return ;

      }
     var  url1 = 'https://shopapp-10706.firebaseio.com/userFavorite/$userId.json?auth=$authToken';
      final fetchFav=await http.get(url1);
      var extractFavID=json.decode(fetchFav.body);



      final List<Product> loadedData=[];
          extractData.forEach((prodId, prodData ) {
          loadedData.add(Product(
             id:prodId,
             title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
             imageUrl: prodData['imageUrl'],
             isFavorite: extractFavID==null?false:extractFavID[prodId]?? false
          ));
          });
      _items=loadedData;
      notifyListeners();



    }
    catch(error){

      throw error;
    }

  }



  Future<void> updateProduct(String id,Product product)async{


    final indexID= _items.indexWhere((prodid) => prodid.id==id);
   if(indexID>=0){
     final url = 'https://shopapp-10706.firebaseio.com/products/$id.json?auth=$authToken';

       await http.patch(url,body: jsonEncode({
       'title':product.title,
       'price':product.price,
       'description':product.description,
       'imageUrl':product.imageUrl,
     }));

   _items[indexID]=product;
   notifyListeners();
   }
  }



  Future<void> removeItem(String prodId)async{

    final url = 'https://shopapp-10706.firebaseio.com/products/$prodId.json?auth=$authToken';

    var existingprodIndex=_items.indexWhere((id) => id.id==prodId);
    var exsitingProduct=_items[existingprodIndex];

    _items.removeWhere((id) => id.id==prodId);
      notifyListeners();

  var response= await http.delete(url);



    if(response.statusCode>=400){
      _items.insert(existingprodIndex, exsitingProduct);
      notifyListeners();
      throw HttpExecption('could not delete product!');
    }
    exsitingProduct=null;


  }
}