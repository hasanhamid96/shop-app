import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String prodId;
  final String title;
  final double price;
  final int quantity;

  CartItem(this.id,this.prodId,this.price,this.quantity,this.title);

  @override
  Widget build(BuildContext context) {



    return Dismissible(
      confirmDismiss:(direction) {
      return  showDialog(context: context,builder:(ctx)=>
            AlertDialog(
              title: Text('Are You Sure'),
              content: Text('do you want to Remove The Item form the Cart ?'),
              elevation: 5,
              actions: <Widget>[
                FlatButton(onPressed: (){
                  Navigator.of(context).pop(true);
                },child: Text('Yes',style: TextStyle(color: Colors.red),),),
                FlatButton(onPressed: (){
                  Navigator.of(context).pop(false);
                },child: Text('No',style: TextStyle(color: Colors.red),)),

              ],
            )

        );
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(id) ,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 15),
        margin: EdgeInsets.symmetric(vertical: 15),
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete,color: Colors.white,),
      ),
      onDismissed: (direction){
return  Provider.of<Cart>(context ,listen: false).removeCart(prodId);
      },

      child: Card(
        elevation: 10,
        margin: EdgeInsets.all(15),
        child:Padding(
          padding:EdgeInsets.all(5) ,
          child: ListTile(

            leading: CircleAvatar(
              backgroundColor: Colors.greenAccent

              ,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text("\$$price",style:
                    TextStyle(color: Colors.black87),)),
              ),),
            title: Text('$title'),
            subtitle: Text("\$${price*quantity}"),

            trailing:
                Text('$quantity x'),



          ),
        ) ,
      ),
    );
  }
}
////8