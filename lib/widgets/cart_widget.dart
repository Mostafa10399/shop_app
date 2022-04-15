import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';

class CartWidget extends StatelessWidget {
  final String id;
  final String productID;
  final String title;
  final double price;
  final int quantity;
  CartWidget(
      {@required this.productID,
      @required this.id,
      @required this.price,
      @required this.quantity,
      @required this.title});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want to remove the item from cart?'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text('No')),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: Text('Yes'))
                  ],
                ));
      },
      onDismissed: ((direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productID);
      }),
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: FittedBox(child: Text('${price}\$')))),
            title: Text(title),
            subtitle: Text('Total: ${price * quantity}\$'),
            trailing: Text('${quantity} x'),
          ),
        ),
      ),
    );
  }
}
