import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_details_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productInfo = Provider.of<Product>(context, listen: false);
    final changeFavorite = productInfo.changeFavoriteStatus;
    final cartInfo = Provider.of<Cart>(context, listen: false);
    final scaffold = Scaffold.of(context);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: productInfo.id),
          child: Hero(
            tag: productInfo.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(productInfo.imageURL),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(ctx).accentColor,
              ),
              onPressed: () => changeFavorite(authData.token, authData.userId)
                  .catchError((error) {
                scaffold.removeCurrentSnackBar();
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text(
                        'Something went wrong while trying to favorite this item.'),
                  ),
                );
              }),
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
          trailing: CartButton(cartInfo: cartInfo, productInfo: productInfo),
          backgroundColor: Colors.black.withOpacity(0.9),
        ),
      ),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({
    Key key,
    @required this.cartInfo,
    @required this.productInfo,
  }) : super(key: key);

  final Cart cartInfo;
  final Product productInfo;

  @override
  _CartButtonState createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  var isLoadingAdd = false;
  var isLoadingRedo = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: isLoadingAdd
            ? CircularProgressIndicator(
                strokeWidth: 3,
              )
            : Icon(
                Icons.shopping_cart,
                color: Theme.of(context).accentColor,
              ),
        onPressed: () async {
          setState(() {
            isLoadingAdd = true;
          });
          await widget.cartInfo.addItemToCart(
              widget.productInfo.id,
              widget.productInfo.price,
              widget.productInfo.title,
              widget.cartInfo.cartItems.containsKey(widget.productInfo.id)
                  ? widget.cartInfo.cartItems[widget.productInfo.id].id
                  : '');
          setState(() {
            isLoadingAdd = false;
          });
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: const Text('You added item to cart '),
              action: SnackBarAction(
                  label: isLoadingRedo ? '...' : 'UNDO',
                  onPressed: () async {
                    setState(() {
                      isLoadingRedo = true;
                    });
                    await widget.cartInfo
                        .removeSingleItem(widget.productInfo.id);
                    setState(() {
                      isLoadingRedo = false;
                    });
                  }),
              duration: const Duration(
                seconds: 2,
              ),
            ),
          );
        });
  }
}
