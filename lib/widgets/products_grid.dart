import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_card_widget.dart';

class ProductsGrid extends StatelessWidget {
  final bool onlyShowFavorites;

  ProductsGrid(this.onlyShowFavorites);

  @override
  Widget build(BuildContext context) {
    print('products grid build run');
    final productsInfo = Provider.of<Products>(context);
    final productsShown = onlyShowFavorites
        ? productsInfo.favoriteItems
        : productsInfo.items;
    print(['grid',productsInfo.items]);

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 7 / 6,
      ),
      itemCount: productsShown.length,
      itemBuilder: (context, idx) => ChangeNotifierProvider.value(
        value: productsShown[idx],
        child: ProductCardWidget(),
      ),
    );
  }
}
