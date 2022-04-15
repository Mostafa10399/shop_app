import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../provider/orders.dart' as osd;

class OrderWidget extends StatefulWidget {
  final osd.OrderItems order;
  OrderWidget(this.order);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  // AnimationController _controller;
  // Animation<Offset> _slidingContainer;
  var expanded = false;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _controller =
  //       AnimationController(vsync: this , duration: Duration(milliseconds: 300));
  //   _slidingContainer = Tween(begin: Offset(0, -1.5), end: Offset(0.0, 0.0))
  //       .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(children: <Widget>[
          ListTile(
            title: Text('${widget.order.amount}\$'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: expanded
                ? min(widget.order.products.length * 20.0 + 110, 200)
                : 0,
            child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              prod.title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${prod.quantity} x ${prod.price} \$',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            )
                          ],
                        ))
                    .toList()),
          )
        ]),
      ),
    );
  }
}
