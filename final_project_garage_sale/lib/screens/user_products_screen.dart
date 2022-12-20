import 'package:final_project_garage_sale/screens/product_info_creation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProductList(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
              onPressed: (() {
                Navigator.of(context)
                    .pushNamed(ProductInfoCreationScreen.routeName);
              }),
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProductList(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProductList(context),
                    child: Consumer<Products>(
                      builder: (context, productsData, child) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                              itemCount: productsData.items.length,
                              itemBuilder: (context, index) => Column(
                                    children: [
                                      UserProductItem(
                                          productsData.items[index].id,
                                          productsData.items[index].title,
                                          productsData.items[index].imageUrl),
                                      const Divider(),
                                    ],
                                  ))),
                    ),
                  ),
      ),
    );
  }
}
