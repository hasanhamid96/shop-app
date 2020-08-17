import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';


class UserProductItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String id;

   UserProductItem(this.id,this.title,this.imageUrl);



  @override
  Widget build(BuildContext context) {

    var scaffold=Scaffold.of(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.blueAccent)),
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          child: Image.network(imageUrl,fit: BoxFit.cover,),
        ),
        title: Text('${title}'),
        trailing:
            Container(
              height: 100,
              width: 99,
              child: Row(
                children: <Widget>[
                  IconButton(
              onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
              },
              icon:Icon(
                  Icons.edit
              ),
              color: Colors.red,),
                  IconButton(
                    onPressed: () async{
                      try {
                      await  Provider.of<Products>(context, listen: false)
                            .removeItem(id);
                      }
                      catch(error){
                        scaffold.showSnackBar(
                            SnackBar(
                               content: Text('item not deleted!',textAlign: TextAlign.center,),

                        ));                    }
                    },
                    icon:Icon(
                        Icons.delete_forever),
                    color: Colors.red,),
                ],
              ),
            ),



      ),
    );
  }
}