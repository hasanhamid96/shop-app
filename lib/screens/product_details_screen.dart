import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static String routeName='/product-details';


  @override
  Widget build(BuildContext context) {

    final productId=ModalRoute.of(context).settings.arguments as String;

   final productItems= Provider.of<Products>(context).findById(productId);

    return Scaffold(
//      appBar: AppBar(
//        title: Text(productItems.title),),
      body: CustomScrollView(

        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title:  Text(productItems.title),
              background: Hero(
                tag: productItems.id,
                child: FadeInImage(
                  placeholder:AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(productItems.imageUrl),
                  fit: BoxFit.cover,
                ),
              ) ,
            ),
            pinned: true,
            expandedHeight: 300,

          ),
          SliverList(
            delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 5,),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text('\$${productItems.price}',style:TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 25,
                        fontWeight:FontWeight.bold

                    )),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text('${productItems.description}',style:TextStyle(
                        color:Colors.blueGrey,
                        fontSize: 20,
                        fontWeight:FontWeight.bold

                    )),
                  ),
                  SizedBox(height: 800,)
                ]
            ),

          ),

        ],

      )





      );
  }
}
