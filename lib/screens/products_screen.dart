import 'package:flutter/material.dart';
import 'package:shop/providers/products.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/budge.dart';
import '../providers/cart.dart';
import 'cart_screen.dart';
import '../providers/themeBloc.dart';

enum FilterOption{
  Favorite,
  All,
}


class ProductScreen extends StatefulWidget {
static const routeName='/Product-screen';

  @override
  _ProductScreenState createState() => _ProductScreenState();
}
Future<void> _refreshIndeciter(BuildContext context) async{
  Provider.of<Products>(context).fetchtheProducts();
}

class _ProductScreenState extends State<ProductScreen> {

static const routeName="/Product-screen" ;

   var _showOnlyFav=false;
   var _isInit=true;
    var _isLoaded=true;

   @override
  void didChangeDependencies()  {

if(_isInit) {
  setState(() {
    _isLoaded=true;
  });

  Provider.of<Products>(context).fetchtheProducts().then((_) {

    setState(() {
      _isLoaded=false;

    });
  });


}
    _isInit=false;
     super.didChangeDependencies();

  }
  @override
  Widget build(BuildContext context) {
     ThemeChanger darkMode=Provider.of<ThemeChanger>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('ShopApp'),
      actions: <Widget>[
         IconButton(icon: Icon(Icons.invert_colors),
      onPressed: ()=>
      darkMode.getTheme()==ThemeData.dark()?
      darkMode.setTheme(ThemeData.light()) :
        darkMode.setTheme(ThemeData.dark())),

        PopupMenuButton(

          icon: Icon(Icons.more_vert),
          itemBuilder:(_) =>[
            PopupMenuItem(
              child: Text('only Favorites'),value: FilterOption.Favorite,),
            PopupMenuItem(
              child: Text('Show All'),value: FilterOption.All,),] ,

          onSelected: (FilterOption selectFilter){

            setState(() {
              if(selectFilter==FilterOption.Favorite)
                _showOnlyFav=true;
              else if(selectFilter==FilterOption.All)
                _showOnlyFav=false;
            });},
        ),

        Consumer<Cart>(builder: (_, Cart, _2) => Badge(

            child: IconButton(icon: Icon(Icons.shopping_cart),
            onPressed: (){


              return Navigator.of(context).pushNamed(CartScreen.routeName);}
            ,)
            ,
            value: Cart.itemCount.toString(),
    ),

        ),
      ],
      ),

      body:RefreshIndicator(
          onRefresh: ()=>_refreshIndeciter(context),

          child: _isLoaded? Center(child: CircularProgressIndicator(),) :ProductGrid(_showOnlyFav)),
    );

  }
}

