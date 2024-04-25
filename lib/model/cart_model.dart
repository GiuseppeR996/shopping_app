import 'dart:collection';

import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  final List<Item> _items = [];
  final Set<Item> _selectedItems = {};
  final Map<Item, int> _selectedItemsQuantity =
      {}; // Mappa per tenere traccia delle quantità dei prodotti selezionati

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);
  UnmodifiableListView<Item> get selectedItems =>
      UnmodifiableListView(_selectedItems);
  UnmodifiableMapView<Item, int> get selectedItemsQuantity => UnmodifiableMapView(
      _selectedItemsQuantity); // Getter per le quantità dei prodotti selezionati

  double get totalPrice => _items.fold(0, (total, item) => total + item.price);
  double get price => _items.fold(0, (total, item) => item.price);
  String get name => _items.fold('', (name, item) => item.name);

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }

  void remove(Item item) {
    _items.remove(item);
    notifyListeners();
  }

//inutili al momento
  void addToSelection(Item item) {
    _selectedItems.add(item);
    _selectedItemsQuantity[item] = (_selectedItemsQuantity[item] ?? 0) +
        1; // Aggiorna la quantità dell'articolo selezionato
    notifyListeners();
  }

  void removeFromSelection(Item item) {
    _selectedItems.remove(item);
    _selectedItemsQuantity
        .remove(item); // Rimuovi la quantità dell'articolo selezionato
    notifyListeners();
  }

  void removeSelectedItems() {
    _items.removeWhere((item) => _selectedItems.contains(item));
    _selectedItems.clear();
    _selectedItemsQuantity
        .clear(); // Rimuovi tutte le quantità dei prodotti selezionati
    notifyListeners();
  }
}

// Fine inutili al momento
class Item {
  final String name;
  final double price;

  Item(this.name, this.price);
}
