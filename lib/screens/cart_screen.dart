import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../widgets/cart_widget.dart';
import '../provider/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Column(children: <Widget>[
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    '${cartItems.totalAmount.toStringAsFixed(2)}\$',
                    style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium
                            .color,
                        fontFamily: 'Lato'),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                OrderButton(cartItems: cartItems)
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: ListView.builder(
                itemCount: cartItems.items.length,
                itemBuilder: ((context, index) {
                  return CartWidget(
                      productID: cartItems.items.keys.toList()[index],
                      id: cartItems.items.values.toList()[index].id,
                      price: cartItems.items.values.toList()[index].price,
                      quantity: cartItems.items.values.toList()[index].quantity,
                      title: cartItems.items.values.toList()[index].title);
                })))
      ]),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartItems,
  }) : super(key: key);

  final Cart cartItems;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cartItems.totalAmount <= 0 || isLoading)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cartItems.items.values.toList(),
                  widget.cartItems.totalAmount);
              setState(() {
                isLoading = false;
              });
              widget.cartItems.clear();
            },
      child: isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(fontFamily: 'Lato'),
            ),
      textColor: Theme.of(context).colorScheme.primary,
    );
  }
}
