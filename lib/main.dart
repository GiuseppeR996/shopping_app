import 'package:shopping_app/firebase_options.dart';
import 'package:shopping_app/model/cart_model.dart';
import 'package:shopping_app/pages/collection_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<CartModel>().mergeItems();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: Consumer<CartModel>(builder: (context, cartModel, child) {
            return CollectionProducts();
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Eliminare gli elementi selezionati
              context.read<CartModel>().removeAll();
            },
            child: const Icon(Icons.delete),
          ),
          bottomSheet: IconButton(
              icon: const Icon(Icons.restore),
              onPressed: () {
                context.read<CartModel>().resetAvailableItems();
              }),
        ),
      ),
    );
  }
}
