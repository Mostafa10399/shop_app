import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

import '../provider/product_provider.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../provider/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductOverViewScreen extends StatefulWidget {
  static final String routeName = '/products-overview';
  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showOnlyFavoriteData = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        print("xz");
        _isLoading = true;
      });
      try {
        await Provider.of<ProductProvider>(context)
            .fetchAndSetProducts()
            .then((_) {
          setState(() {
            print('xy');
            _isLoading = false;
          });
        });
      } catch (error) {
        // setState(() {
        //   _isLoading = false;
        // });
      }

      _isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorite) {
                  _showOnlyFavoriteData = true;
                } else {
                  _showOnlyFavoriteData = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
        title: Text('My Shop'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavoriteData),
    );
  }
}
