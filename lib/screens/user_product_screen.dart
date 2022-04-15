import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../provider/product_provider.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user_product_screen';

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<ProductProvider>(ctx, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: (() => _refreshProducts(context)),
                    child: Consumer<ProductProvider>(
                      builder: (ctx, productsProvider, child) => Padding(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: productsProvider.items.length,
                            itemBuilder: (ctx, index) {
                              return Column(
                                children: [
                                  UserProductItem(
                                    productsProvider.items[index].id,
                                    productsProvider.items[index].imageUrl,
                                    productsProvider.items[index].title,
                                  ),
                                  Divider()
                                ],
                              );
                            }),
                      ),
                    ),
                  ),
      ),
    );
  }
}
