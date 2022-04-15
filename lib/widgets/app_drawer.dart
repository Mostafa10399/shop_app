import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';
import '../screens/order_screen.dart';
import '../screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  Widget buildDrawerItem(IconData icon, String title, Function handler) {
    return Column(
      children: <Widget>[
        Divider(),
        ListTile(leading: Icon(icon), title: Text(title), onTap: handler),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              'Hello Friends',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            automaticallyImplyLeading: false,
          ),
          buildDrawerItem(Icons.shopping_cart, 'Shop', () {
            Navigator.of(context).pushReplacementNamed('/');
          }),
          buildDrawerItem(Icons.payment, 'Orders', () {
            Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            // Navigator.of(context)
            //     .pushReplacement(CustomRoute(builder: (ctx) => OrderScreen()));
          }),
          buildDrawerItem(Icons.payment, 'Mange Production', () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routeName);
          }),
          buildDrawerItem(Icons.exit_to_app, 'LogOut', () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logOut();
          })
        ],
      ),
    );
  }
}
