import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartContent extends StatefulWidget {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  int quantity;
  CartContent({
    this.id,
    this.title,
    this.price,
    this.imageUrl,
    this.quantity,
  });

  @override
  _CartContentState createState() => _CartContentState();
}

class _CartContentState extends State<CartContent> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(widget.id),
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Text('Remove this item?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        cart.removeItem(widget.id);
      },
      child: Card(
        child: ListTile(
          minVerticalPadding: 15,
          minLeadingWidth: 100,
          leading: Container(
            height: 60,
            width: 100,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            '${widget.title} - \$ ${(widget.price * widget.quantity).toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Row(
            children: [
              FittedBox(
                  child: Text('\$ ${widget.price.toStringAsFixed(2)} X ')),
              IconButton(
                icon: Icon(Icons.arrow_drop_down),
                onPressed: () {
                  cart.decreaseQuantity(widget.id);
                },
              ),
              Text(
                '${widget.quantity}',
              ),
              IconButton(
                icon: Icon(Icons.arrow_drop_up),
                onPressed: () {
                  cart.increaeQty(widget.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
