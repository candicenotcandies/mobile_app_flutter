import 'package:final_project_garage_sale/providers/auth.dart';
import 'package:final_project_garage_sale/providers/cart.dart';
import 'package:final_project_garage_sale/providers/orders.dart';
import 'package:final_project_garage_sale/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import './screens/product_overview.dart';
import './screens/product_detail.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/product_info_creation.dart';
import './screens/auth_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //listen to the providers anywhere in the application
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (context) => Products('', '', []),
              update: (context, authData, previous) => Products(
                  authData.token ?? '',
                  authData.userId ?? '',
                  previous == null ? [] : previous.items)),
          // ChangeNotifierProvider(
          //   create: (context) => Products(),
          // ),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (context) => Orders('', '', []),
              update: (context, authData, previous) => Orders(
                  authData.token ?? '',
                  authData.userId ?? '',
                  previous == null ? [] : previous.orders)),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          // ChangeNotifierProvider(
          //   create: (context) => Orders(),
          // ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            title: 'GarageSale',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
                  .copyWith(secondary: Colors.amberAccent),
              fontFamily: 'Lato',
            ),
            home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              UserProductsScreen.routeName: (context) => UserProductsScreen(),
              ProductInfoCreationScreen.routeName: (context) =>
                  ProductInfoCreationScreen(),
            },
          ),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
      ),
      body: const Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
