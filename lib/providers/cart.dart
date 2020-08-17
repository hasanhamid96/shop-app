import 'package:flutter/material.dart';


class CartItem{

  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
       {@required this.id, //this cart id is diffirent from product id that we use map insted of list
  @required this.title,
  @required     this.quantity,
  @required   this.price});

}

class Cart with ChangeNotifier{

  // Map<string for id, cardItem for carts كم ايتم بالكارت
  Map<String, CartItem>_items={};

  Map<String, CartItem> get items{

    //with map we use{}  with list we use [] hasan hamid talk to Y idiot
    return {..._items};
  }
  void addItem(String prodId,double price,String title){

            //اذا ال id  يحتوي على كي ف ادخل بال if
        if(_items.containsKey(prodId)){
          //how to update map change one value or more
            _items.update(prodId, (existCart) => CartItem(
              id:  existCart.id,
            title :   existCart.title,
            quantity:   existCart.quantity+1,
             price:   existCart.price)) ;
          }
        else{
          //for map only apply a new cart
          _items.putIfAbsent(prodId, () => CartItem(
            id:   DateTime.now().toString(),
            title :   title,
            quantity:     1,
            price:     price,
          ));
        }
        notifyListeners();
  }
  int get itemCount{
    return _items.length;
  }
  double  get totalAmount{

    var total=0.0;
    _items.forEach((key, cartItemValue) {
      total+=cartItemValue.price*cartItemValue.quantity;
    });
    return total;
}

  void removeCart(String prodId) {
    _items.remove(prodId);
    notifyListeners();
  }
void removeSingleItem(String prodId){

 if(! _items.containsKey(prodId))
   return;
 if(_items[prodId].quantity>1)
   _items.update(prodId, (existingCardItem) => CartItem(
       id: existingCardItem.id,
       title :  existingCardItem.title,
       quantity:  existingCardItem.quantity-1,
       price:   existingCardItem.price
   ));
 if(_items[prodId].quantity==0)
   _items.remove(prodId);
 notifyListeners();
}


  void clear(){
    _items={};
    notifyListeners();
  }
}
