import 'package:shopping_app/model/cart_model.dart';
import 'package:shopping_app/pages/collection_products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<Item> availableItems = [
    Item('Prodotto 1', 10),
    Item('Prodotto 2', 20),
    Item('Prodotto 3', 30),
    // Aggiungi altri oggetti se necessario
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: CollectionProducts(availableItems),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Eliminare gli elementi selezionati
              context.read<CartModel>().removeAll();
            },
            child: const Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
