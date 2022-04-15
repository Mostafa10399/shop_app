import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/orders.dart';
import '../widgets/order_widget.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order_screen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _ordersFuture;
  Future _obtainOrderFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetData();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Building Orders');
    // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnapShot.error != null) {
              //Do error handling stuff
              return Center(
                child: Text('an error occurred'),
              );
            } else {
              return Consumer<Orders>(
                  builder: (ctx, ordersData, child) => ListView.builder(
                      itemCount: ordersData.orders.length,
                      itemBuilder: (ctx, index) {
                        return OrderWidget(ordersData.orders[index]);
                      }));
            }
          },
        ));
  }
}
