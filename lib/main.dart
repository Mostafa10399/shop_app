import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './screens/order_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import '../screens/splash_screen.dart';

import './provider/product_provider.dart';
import './provider/cart.dart';
import './provider/orders.dart';
import './provider/auth.dart';

import './helpers/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, ProductProvider>(
            update: (ctx, auth, previousProduct) => ProductProvider(
                auth.token,
                previousProduct == null ? [] : previousProduct.items,
                auth.userID),
          ),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (context, auth, previousOrders) => Orders(
                auth.token,
                previousOrders == null ? [] : previousOrders.orders,
                auth.userID),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                appBarTheme: AppBarTheme(
                    titleTextStyle:
                        TextStyle(color: Colors.white, fontSize: 20)),
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransationBuilder(),
                  TargetPlatform.iOS: CustomPageTransationBuilder(),
                }),
                primarySwatch: Colors.purple,
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                        .copyWith(secondary: Colors.deepOrange)),
            home: auth.isAuth
                ? ProductOverViewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: ((context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen())),
            routes: {
              // '/': (context) => ProductOverViewScreen(),
              ProductOverViewScreen.routeName: (context) =>
                  ProductOverViewScreen(),
              AuthScreen.routeName: (context) => AuthScreen(),
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrderScreen.routeName: (context) => OrderScreen(),
              UserProductScreen.routeName: ((context) => UserProductScreen()),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            },
          ),
        ));
  }
}
