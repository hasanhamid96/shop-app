import 'package:flutter/material.dart';
import 'package:shop/widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName='/order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isInit=true;
  var _isLoaded=false;




  @override
  Widget build(BuildContext context) {


    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('your orders'),
      ),

      body: FutureBuilder(
          future: Provider.of<Orders>(context,listen: false).fetchOrders(),
          builder: (ctx,dataFromFuture){

        if(dataFromFuture.connectionState==ConnectionState.waiting){
       return  Center(child: CircularProgressIndicator() ,);
        }
        else if(dataFromFuture.error!=null){
         return Text('something wrong happend!!') ;}
         else if(dataFromFuture.connectionState==ConnectionState.done){
           return Consumer<Orders>(builder:(ctx,ordersData,child)=>ListView.builder(
               itemCount: ordersData.orders.length ,
               itemBuilder:(ctx,i) =>OrderItem(ordersData.orders[i])),);
        }
         return null;

      }
      )



    );
  }
}
