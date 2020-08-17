import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop/providers/products.dart';
import '../providers/product.dart';
import '../screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final product=Provider.of<Product>(context,listen: false);
    final products=Provider.of<Products>(context,listen: false);
    final cart=Provider.of<Cart>(context,listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),

      child: GestureDetector(
        onTap: (){ 
          Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,arguments: product.id);

        },

        child: GridTile(

            child:Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder:AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ) ,

            header: Text("${product.price} \$",textAlign: TextAlign.center,
              style: TextStyle(
                  backgroundColor:Theme.of(context).primaryColor,
              color:Theme.of(context).accentColor),),
            footer: GridTileBar(
              title: Text(product.title,),
               backgroundColor: Colors.black54,
               
               trailing:Consumer<Product>(
                 builder: (ctx,product,child)=>

                  IconButton(onPressed: (){
                   product.toggleFavoritesProduct(products.authToken,products.userId);
                 },icon: Icon(product.isFavorite? Icons.favorite :Icons.favorite_border),
                   color:   Theme.of(context).accentColor,),
               ),


               leading: IconButton(
                 icon: Icon(Icons.shopping_cart),
                 onPressed: (){
                    cart.addItem(product.id,product.price,product.title);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Item Add to Cart'),
                          backgroundColor: Colors.black54,
                          duration: Duration(seconds: 2),
                          action: SnackBarAction(
                            onPressed: (){
                              cart.removeSingleItem(product.id);

                            },
                            label: "Undo",textColor: Colors.red,
                          ),

                        ));
               },
                 color:   Theme.of(context).accentColor,),
               ),
        ),
         )
      );
    
  }
}
