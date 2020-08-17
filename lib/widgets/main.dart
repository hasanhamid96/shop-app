import 'package:flutter/material.dart';
import 'package:shop/helper/custom_route.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/screens/auth_screen.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../providers/themeBloc.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/order_screen.dart';
import 'package:shop/screens/user_product.dart';
import '../screens/products_screen.dart';
import '../screens/product_details_screen.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return  ChangeNotifierProvider(
           create: (_)=>
           ThemeChanger(ThemeData.light()),

           child: MaterialAppWithTheme(),

      );
  }
}

class MaterialAppWithTheme extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    final theme=Provider.of<ThemeChanger>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth,Products>(
            update:(ctx,auth,prevousproducts)=>Products(
              auth.token,
                auth.userId,
                prevousproducts==null?[]:prevousproducts.items
            )),
        ChangeNotifierProxyProvider<Auth,Orders>(
          update: (context, auth, prevousOrder) =>
          Orders(
            auth.token,
            auth.userId,
            prevousOrder==null?[]:prevousOrder
                  .orders,
          ),),
        ChangeNotifierProvider.value(value: Cart())
      ],
      child: Consumer<Auth>(builder:(ctx,auth,_)=>
          MaterialApp(

            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme:theme.getTheme()==ThemeData.dark()?
            theme.getTheme()
                :ThemeData(
              primarySwatch: Colors.yellow,
              accentColor: Colors.redAccent,
              backgroundColor: Colors.pinkAccent,
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android:CustomPageTranstionBuilder(),
                  TargetPlatform.iOS:CustomPageTranstionBuilder(),
                }
              )
            ),


            home: auth.isAuth? ProductScreen():AuthScreen(),

            initialRoute: '/',
            routes: {
              ProductScreen.routeName:(ctx)=>ProductScreen(),
              ProductDetailsScreen.routeName: (ctx)=>ProductDetailsScreen(),
              CartScreen.routeName:(ctx) =>CartScreen(),
              OrderScreen.routeName:(ctx)=>OrderScreen(),
              EditProductScreen.routeName:(ctx)=>EditProductScreen(),
              UserProduct.routeName:(ctx)=>UserProduct(),
            },


          )
      ) ,
    );
  }
}

