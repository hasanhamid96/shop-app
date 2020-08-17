import 'package:flutter/material.dart';
import '../screens/order_screen.dart';
import '../screens/product_details_screen.dart';
import '../screens/user_product.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend'),
            automaticallyImplyLeading: false,

          ),
          ListTile(
            leading: Icon(Icons.shop,),
            title: Text('Shop'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.add_shopping_cart,),
            title: Text('Your Orders'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.edit,),
            title: Text('Manage Products'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(UserProduct.routeName);
            },
          ),

        ],
      ),
    );
  }
}
