import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart'show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {


  static String routeName='/cart-details';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {

    final cart =Provider.of<Cart>(context);
    final orderButton=Provider.of<Orders>(context,listen:false);
    var _isLoaded=false;
    return Scaffold(

      appBar: AppBar(
        title: Text("title"),),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Card(

            elevation: 10,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                Text('Total:',style: TextStyle(fontSize: 20),),
                SizedBox(width: 20,),
                  Chip(label: Text(' \$${cart.totalAmount.toStringAsFixed(2)}',),
                    backgroundColor:Theme.of(context).primaryColor,
                       ),
                  FlatButton(
                    child:_isLoaded?CircularProgressIndicator(): Text('order now',style: TextStyle(fontSize: 15),),
                    onPressed:(cart.totalAmount<=0||_isLoaded)? null:()async{

                          try {
                            setState(() {
                              _isLoaded=true;

                            });
                              await orderButton.addOrder(cart.items.values
                                .toList(), cart.totalAmount);
                            setState(() {
                              _isLoaded=false;
                            });
                            cart.clear();
                          }
                          catch(error){
                            await showDialog<Null>(context: context,builder: (ctx)=>
                                AlertDialog(
                                  title: Text('an error occurred '),
                                  content: Text("something went worng!!"),
                                  actions: <Widget>[FlatButton(
                                    child: Text('close'),
                                    onPressed: (){
                                      Navigator.of(ctx).pop();

                                    },)],
                                )
                            );
                          }


                    },
                    color: Colors.blueAccent,
                   ),

                ]
                   ,),

            ),
  ),
          Expanded(  child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx,i)=>
                  CartItem(cart.items.values.toList()[i].id,
                      cart.items.keys.toList()[i],
                      cart.items.values.toList()[i].price,
                      cart.items.values.toList()[i].quantity,
                      cart.items.values.toList()[i].title
                  )
          ),
          )
        ],
      ) ,
    );
  }
}
