import 'package:flutter/material.dart';
import 'product_item.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';


class ProductGrid extends StatelessWidget {



  List<Product> loadedItems=[];

   final bool showOnlyFav;

  ProductGrid(this.showOnlyFav);


  @override
  Widget build(BuildContext context) {

    final productData = Provider.of<Products>(context);
    final loadedItems=showOnlyFav ? productData.isFav :productData.items;


    return GridView.builder(
      padding: EdgeInsets.all(10),

      itemCount: loadedItems.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(

        value:loadedItems[index],
        child:  ProductItem(),


      ),

      gridDelegate : SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio:3/2,
      ),


    );
  }
}
