import 'package:flutter/material.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        AppBar(
          title: const Text('Hello Friend!'),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.shop_2_rounded),
          title: const Text('Shop'),
          onTap: (() {
            Navigator.of(context).pushReplacementNamed('/');
          }),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.payment_rounded),
          title: const Text('Orders'),
          onTap: (() {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          }),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit_attributes_rounded),
          title: const Text('Manage Products'),
          onTap: (() {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
          }),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app_rounded),
          title: const Text('Logout'),
          onTap: (() {
            Provider.of<Auth>(context, listen: false).logOut();
            // Navigator.of(context)
            //     .pushReplacementNamed(UserProductsScreen.routeName);
          }),
        ),
      ]),
    );
  }
}
