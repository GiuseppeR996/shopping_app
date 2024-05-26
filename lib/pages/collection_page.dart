// ignore_for_file: prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/model/cart_model.dart';
import 'package:shopping_app/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/pages/admin_page.dart';

class CollectionProducts extends StatefulWidget {
  const CollectionProducts({super.key});

  @override
  State<StatefulWidget> createState() => CollectionProductsState();
}

class CollectionProductsState extends State<CollectionProducts> {
  @override
  Widget build(BuildContext context) {
    void gotoCart() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ShoppingCart()));
    }

    final database = FirebaseDatabase.instance;
    Query dbRef = database.ref().child('availableItems');
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'DrawerHeader',
              textAlign: TextAlign.center,
            ),
          ),
          InkWell(
            onTap: () {
              scaffoldKey.currentState!.openEndDrawer();
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  Icon(Icons.menu),
                  SizedBox(width: 8.0),
                  Text("Home"),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Admin"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminPage()));
            },
          ),
        ]),
      ),
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
          /*Expanded(
              child: FirebaseAnimatedList(
                  query: dbRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map itemMaps = snapshot.value as Map<dynamic, dynamic>;
                    itemMaps['key'] = snapshot.key;
                    return listItem(itemMaps: itemMaps);
                  })),*/
          Expanded(
            child: Consumer<CartModel>(builder: (context, cart, child) {
              final items = cart.AvItems;
              if (items.isEmpty) {
                // Show a loading indicator (e.g., CircularProgressIndicator())
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final price = item.price;
                    String formattedPrice =
                        NumberFormat.currency(locale: 'it', symbol: '€')
                            .format(price);
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('Price: $formattedPrice'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Aggiungi questo articolo al carrello
                          context.read<CartModel>().add(item);
                        },
                        child: const Text('Aggiungi al carrello'),
                      ),
                    );
                  },
                );
              }
            }),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Consumer<CartModel>(
                builder: (context, cart, child) {
                  if (cart.totalPrice > 0) {
                    String formattedPrice =
                        NumberFormat.currency(locale: 'it', symbol: '€')
                            .format(cart.price);
                    String formattedTotalPrice =
                        NumberFormat.currency(locale: 'it', symbol: '€')
                            .format(cart.totalPrice);
                    return Column(
                      children: [
                        Text(cart.name),
                        Text(formattedPrice),
                        Text('Totale: $formattedTotalPrice')
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              )),
        ],
      ),
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
          // Aggiungi questo articolo al carrello
          context
              .read<CartModel>()
              .add(Item(itemMaps['name'], itemMaps['price']));
        },
        child: const Text('Aggiungi al carrello'),
      ),
    );
  }
}
