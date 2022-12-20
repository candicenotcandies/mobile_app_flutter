import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({super.key});

  // @override
  // State<OrdersScreen> createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;

  // @override
  // void initState() {
  //   _isLoading = true;
  //   Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then(
  //     (value) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     },
  // //   );

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null &&
                  snapshot.connectionState != ConnectionState.none) {
                print(snapshot.error);
                return const Center(child: Text('There is an error.'));
              } else {
                return Consumer<Orders>(
                    builder: (context, value, child) => ListView.builder(
                          itemCount: value.orders.length,
                          itemBuilder: (context, index) =>
                              OrderItem(value.orders[index]),
                        ));
              }
            }
          },
        ));
  }
}
