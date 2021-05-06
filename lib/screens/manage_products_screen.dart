import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/add_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/manage_products_content.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage-products';

  Future<void> _refreshScreen(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshScreen(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return RefreshIndicator(
            onRefresh: () => _refreshScreen(context),
            child: snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Products>(
                    builder: (context, products, _) => ListView.builder(
                      itemCount: products.items.length,
                      itemBuilder: (ctx, i) => ManageProductsContent(
                        products.items[i].id,
                        products.items[i].title,
                        products.items[i].imageUrl,
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
