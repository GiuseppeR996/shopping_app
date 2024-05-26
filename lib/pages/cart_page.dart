import 'package:intl/intl.dart';
import 'package:shopping_app/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Consumer<CartModel>(builder: (context, cart, child) {
        final items = cart.items;
        String formattedTotalPrice =
            NumberFormat.currency(locale: 'it', symbol: '€')
                .format(cart.totalPrice);
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  String formattedPrice =
                      NumberFormat.currency(locale: 'it', symbol: '€')
                          .format(item.price);
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Price $formattedPrice'),
                    leading: IconButton(
                        icon: const Icon(Icons.cancel_outlined),
                        onPressed: () {
                          context.read<CartModel>().remove(item);
                        }),
                  );
                },
              ),
            ),
            if (cart.totalPrice > 0) ...[
              Column(
                children: [Text('Totale: $formattedTotalPrice')],
              ),
            ],
          ],
        );
      }),
    );
  }
}
