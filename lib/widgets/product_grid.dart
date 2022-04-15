import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import './product_item.dart';
import '../provider/product_provider.dart';

class ProductGrid extends StatelessWidget {
  @override
  final bool showFav;
  ProductGrid(this.showFav);

  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final products = showFav ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(
              // id: products[index].id,
              // imageUrl: products[index].imageUrl,
              // title: products[index].title,
              ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
