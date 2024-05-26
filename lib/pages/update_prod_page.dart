import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/model/cart_model.dart';
import 'package:shopping_app/pages/admin_page.dart';

class UpdateProdPage extends StatefulWidget {
  final Map itemMaps;
  const UpdateProdPage({Key? key, required this.itemMaps}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UpdateProdPageState();
}

class UpdateProdPageState extends State<UpdateProdPage> {
  @override
  Widget build(BuildContext context) {
    final itemName = widget.itemMaps['name'];
    final itemPrice = widget.itemMaps['price'];
    String updatedItemName = '';

    TextEditingController controllerName =
        TextEditingController(text: itemName);
    TextEditingController controllerPrice =
        TextEditingController(text: '$itemPrice');
    return Scaffold(
        appBar: AppBar(title: Text(itemName)),
        body: Center(
          child: Column(children: [
            TextField(
              textAlign: TextAlign.center,
              controller: controllerName,
              decoration: const InputDecoration(
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  hintText: 'Enter text here',
                  labelText: 'Name'),
            ),
            TextField(
              textAlign: TextAlign.center,
              controller: controllerPrice,
              decoration: const InputDecoration(
                floatingLabelAlignment: FloatingLabelAlignment.center,
                hintText: 'Enter text here',
                labelText: 'Price',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Consumer<CartModel>(builder: (context, cartModel, child) {
                List<Item> availableItems = cartModel.availableItems;
                return ElevatedButton(
                  onPressed: () {
                    updatedItemName = controllerName.text;
                    double updatedItemPrice =
                        double.tryParse(controllerPrice.text) ?? 0.00;
                    if (updatedItemName.isNotEmpty ||
                        controllerPrice.text.isNotEmpty) {
                      int index = int.parse(widget.itemMaps['key']);
                      availableItems[index] =
                          Item(updatedItemName, updatedItemPrice);
                      setState(() {
                        availableItems = availableItems;
                        context
                            .read<CartModel>()
                            .updateAvailableItems(availableItems);
                      });
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminPage()));
                  },
                  child: const Text('Aggiorna'),
                );
              }),
            )
          ]),
        ));
  }
}
