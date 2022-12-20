import 'package:final_project_garage_sale/screens/cart_screen.dart';
import 'package:final_project_garage_sale/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

//main view of the app
class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _loading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _loading = true;
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _loading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GarageSale'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: FilterOptions.Favorites, child: Text("Your Favs")),
              const PopupMenuItem(
                  value: FilterOptions.All, child: Text("All Items")),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartInfo, ch) => Badge(
              value: cartInfo.itemCount.toString(),
              child: ch!,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.red),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
