import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/model/cart_model.dart';
import 'package:shopping_app/pages/create_prod_page.dart';
import 'package:shopping_app/pages/update_prod_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<StatefulWidget> createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    final database = FirebaseDatabase.instance;
    Query dbRef = database.ref().child('availableItems');
    return Scaffold(
      appBar: AppBar(
          title: const Text('Admin'), backgroundColor: Colors.lightGreen),
      body: Column(children: [
        Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.all(8),
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateProd()));
              },
              child: const Text('Crea prodotto')),
        ),
        Expanded(
            child: FirebaseAnimatedList(
                query: dbRef,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map itemMaps = snapshot.value as Map<dynamic, dynamic>;
                  itemMaps['key'] = snapshot.key;
                  return listItem(itemMaps: itemMaps);
                })),
      ]),
    );
  }

  Widget listItem({required Map itemMaps}) {
    final price = itemMaps['price'];
    String formattedPrice =
        NumberFormat.currency(locale: 'it', symbol: '€').format(price);
    return ListTile(
      title: Text(itemMaps['name']),
      subtitle: Text('Price: $formattedPrice'),
      trailing: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpdateProdPage(itemMaps: itemMaps)));
        },
        child: const Text('Modifica'),
      ),
      leading: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () {
            int index = int.parse(itemMaps['key']);
            context.read<CartModel>().removedb(index);
          }),
    );
  }
}
