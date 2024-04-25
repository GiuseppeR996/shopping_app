import 'package:shopping_app/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCart extends StatelessWidget {
  final String itemName;
  final double itemPrice;
  final String currency = '\$';

  const ShoppingCart({Key? key, this.itemName = '', this.itemPrice = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Consumer<CartModel>(builder: (context, cart, child) {
        final items = cart.items;
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('$currency${item.price}'),
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
                children: [Text('Totale: ${cart.totalPrice} €')],
              ),
            ],
          ],
        );
      }),
    );
  }
}
