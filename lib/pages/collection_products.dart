// ignore_for_file: prefer_const_constructors

import 'package:shopping_app/model/cart_model.dart';
import 'package:shopping_app/pages/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionProducts extends StatefulWidget {
  final List<Item> availableItems;

  const CollectionProducts(this.availableItems, {super.key});

  @override
  State<StatefulWidget> createState() => CollectionProductsState();
}

class CollectionProductsState extends State<CollectionProducts> {
  @override
  Widget build(BuildContext context) {
    final availableItems = widget.availableItems;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Colors.blue[200],
          title: const Text('Shopping'),
          actions: [
            Consumer<CartModel>(
              builder: (context, cart, child) {
                final items = cart.items;
                return Padding(
                    padding: EdgeInsets.only(right: 32),
                    child: IconButton(
                      onPressed: () {
                        void gotoCart() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ShoppingCart()));
                        }

                        gotoCart();
                      },
                      icon: Column(children: [
                        Icon(Icons.shopping_cart),
                        if (items.isNotEmpty) ...[
                          InkWell(
                            child: Container(
                              width: 16,
                              height: 16,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber,
                              ),
                              child: Text(
                                '${items.length}',
                                textScaler: TextScaler.linear(0.9),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ]),
                    ));
              },
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: availableItems.length,
                itemBuilder: (context, index) {
                  final item = availableItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Price: \$${item.price}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Aggiungi questo articolo al carrello
                        context.read<CartModel>().add(item);
                      },
                      child: const Text('Aggiungi al carrello'),
                    ),
                  );
                },
              ),
            ),
            Consumer<CartModel>(
              builder: (context, cart, child) {
                if (cart.totalPrice > 0) {
                  return Column(
                    children: [
                      Text(cart.name),
                      Text('${cart.price} €'),
                      Text('Totale: ${cart.totalPrice} €')
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ));
  }
}
