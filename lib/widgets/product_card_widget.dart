import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_details_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productInfo = Provider.of<Product>(context, listen: false);
    final changeFavorite = productInfo.changeFavoriteStatus;
    final cartInfo = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: productInfo.id),
          child: Image.network(
            productInfo.imageURL,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(ctx).accentColor,
              ),
              onPressed: () => changeFavorite(),
            ),
          ),
          title: Text(
            productInfo.title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cartInfo.addItemToCart(
                    productInfo.id, productInfo.price, productInfo.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You added item to cart '),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () => cartInfo.removeSingleItem(productInfo.id),
                    ),
                    duration: Duration(seconds: 2,),
                  ),
                );
              }),
          backgroundColor: Colors.black.withOpacity(0.9),
        ),
      ),
    );
  }
}
