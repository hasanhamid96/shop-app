import 'package:flutter/material.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';



class UserProduct extends StatefulWidget {

  static const routeName='/user-Product';

  @override
  _UserProductState createState() => _UserProductState();
}
Future<void> _refreshIndicator(BuildContext context) async{
  Provider.of<Products>(context,listen: false).fetchtheProducts(true);
}

class _UserProductState extends State<UserProduct> {
  @override
  Widget build(BuildContext context) {
    
//    final product=Provider.of<Products>(context).items;
    
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Input Your Products'),
      actions: <Widget>[IconButton(
        onPressed: (){
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        },
      icon: Icon(Icons.add),
      )],),
      body: FutureBuilder(
        future: _refreshIndicator(context),
        builder:(ctx,snapshot,)=>
            snapshot.connectionState==ConnectionState.waiting?Center(child: CircularProgressIndicator(),)
            :RefreshIndicator(

          onRefresh: ()=>_refreshIndicator(context),
          child: Consumer<Products>(

            builder:(ctx,product,_)=> ListView.builder(
              itemCount: product.items.length,
             itemBuilder: (_,i)=>
                 UserProductItem(product.items[i].id,product.items[i].title,product.items[i].imageUrl),
            ),
          ),
        ),
      ),

    );
  }
}


