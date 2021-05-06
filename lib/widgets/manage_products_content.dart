import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/add_product_screen.dart';

class ManageProductsContent extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  ManageProductsContent(
    this.id,
    this.title,
    this.imageUrl,
  );
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(title),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AddProductScreen.routeName, arguments: id);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
