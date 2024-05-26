import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/main.dart';
import 'package:shopping_app/model/cart_model.dart';
import 'package:shopping_app/pages/collection_page.dart';

class CreateProd extends StatefulWidget {
  const CreateProd({super.key});

  @override
  State<StatefulWidget> createState() => CreateProdState();
}

class CreateProdState extends State<CreateProd> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuovo Prodotto')),
      body: Column(
        children: [
          const Text('Nome prodotto'),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              floatingLabelAlignment: FloatingLabelAlignment.center,
              hintText: 'Enter text here',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z 0-9]'))
            ],
          ),
          const Text('Prezzo'),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(
              floatingLabelAlignment: FloatingLabelAlignment.center,
              hintText: 'Enter text here',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
          ),
          ElevatedButton(
            onPressed: () {
              String productName = _nameController.text;
              double productPrice =
                  double.tryParse(_priceController.text) ?? 0.00;

              final CartModel cartModel =
                  Provider.of<CartModel>(context, listen: false);

              cartModel.adddb(Item(productName, productPrice));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ));
            },
            child: const Text('Crea Prodotto'),
          ),
        ],
      ),
    );
  }
}
