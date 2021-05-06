import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = 'product-details';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).searchById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 500,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(loadedProduct.imageUrl),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Divider(),
              Chip(
                backgroundColor: Colors.lightGreen,
                label: Text(
                  '\$ ${loadedProduct.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Text(
                  loadedProduct.description,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  softWrap: true,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
