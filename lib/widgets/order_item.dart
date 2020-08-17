import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
static const routeName='/orserItem';
final Order ordered;

  OrderItem(this.ordered);
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with SingleTickerProviderStateMixin {

  bool _expands=false;


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:_expands? min(widget.ordered.products.length*20.0+180,200):95,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
          ListTile(
            title: Text('\$${widget.ordered.amount.toStringAsFixed(3)}'),
            subtitle: Text(DateFormat(
              'dd/ MM/ yyyy hh:mm'
            ).format(widget.ordered.dateTime)),
            trailing: IconButton(
              icon: Icon(!_expands?Icons.expand_more:Icons.expand_less),
              onPressed: (){

                setState(() {
                  _expands=!_expands;
                });
              },
            ),
          ),


              AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                height: _expands? min(widget.ordered.products.length*20.0+50,100):0,
               child: ListView(
                  children: widget.ordered.products.map((prod)=>
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                      Text('${prod.title}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,),
                        textAlign: TextAlign.start,),



                      Text(' ${prod.price} x${prod.quantity}'),

                    ],),
                  )).toList(),
                ),
            ),


          ],
        ),
      ),
    );
  }
}
