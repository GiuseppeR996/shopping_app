import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  final List<Item> availableItemsDefault = [
    Item('Prodotto 1', 10),
    Item('Prodotto 2', 20),
    Item('Prodotto 3', 30),
    Item('Prodotto 4', 40),
    Item('Prodotto 5', 50),
  ];
  List<Item> availableItems = [];
  final List<Item> _items = [];
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);
  UnmodifiableListView<Item> get AvItems =>
      UnmodifiableListView(availableItems);

  double get totalPrice => _items.fold(0, (total, item) => total + item.price);
  double get price => _items.fold(0, (total, item) => item.price);
  String get name => _items.fold('', (name, item) => item.name);

  Future<void> mergeItems() async {
    mergeAvailableItemsData();
    mergeCartItemsData();
  }

  void mergeAvailableItemsData() async {
    final database = FirebaseDatabase.instance.ref();
    final snapshot = database.child('availableItems');

    bool _hasInitialized = false;
    snapshot.onValue.listen((event) {
      if (!_hasInitialized) {
        for (var child in event.snapshot.children) {
          dynamic itemData = child.value; // Get the dynamic data for each item
          Item item = Item.fromJson(
              itemData); // Convert to Item using your 'fromJson' method
          availableItems.add(item); // Add the converted Item to the list
        }
        _hasInitialized = true;
      }
      notifyListeners();
    });
  }

  void mergeCartItemsData() async {
    final database = FirebaseDatabase.instance.ref();
    final snapshot = database.child('cartItems');
    bool _hasInitialized = false;
    snapshot.onValue.listen((event) {
      if (!_hasInitialized) {
        for (var child in event.snapshot.children) {
          dynamic itemData = child.value; // Get the dynamic data for each item
          Item item = Item.fromJson(
              itemData); // Convert to Item using your 'fromJson' method
          _items.add(item); // Add the converted Item to the list
        }
        _hasInitialized = true;
      }
      notifyListeners();
    });
  }

  void add(Item item) {
    _items.add(item);
    updateCartItems(_items);
    notifyListeners();
  }

  void addProd(Item item) {
    availableItems.add(item);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    updateCartItems(_items);
    notifyListeners();
  }

  void remove(Item item) {
    _items.remove(item);
    updateCartItems(_items);
    notifyListeners();
  }

  void adddb(Item item) {
    print(availableItems);
    availableItems.add(item);
    updateAvailableItems(availableItems);
    notifyListeners();
  }

  void removedb(int key) {
    List<Item> avItems = availableItems;
    availableItems.removeAt(key);
    updateAvailableItems(availableItems);
    notifyListeners();
  }

  void duplicateItemDB(Item item) {
    availableItems.add(item);
    updateAvailableItems(availableItems);
    notifyListeners();
  }

  void resetAvailableItems() {
    final database = FirebaseDatabase.instance;
    final dbRef = database.ref().child('availableItems');
    final itemMap = availableItemsDefault.map((item) => item.toMap());
    availableItems = availableItemsDefault;
    dbRef.set(itemMap);
    notifyListeners();
  }

  void updateAvailableItems(List<Item> avItem) {
    final database = FirebaseDatabase.instance;
    final dbProdRef = database.ref().child('availableItems');
    final itemMap = avItem.map((item) => item.toMap());

    dbProdRef.set(itemMap);
  }

  void updateCartItems(List<Item> avItem) {
    final database = FirebaseDatabase.instance;
    final dbCartRef = database.ref().child('cartItems');
    final cartItemMap = avItem.map((itemCart) => itemCart.toMap());

    dbCartRef.set(cartItemMap);
  }
}

// Fine inutili al momento
class Item {
  final String name;
  final double price;

  Item(this.name, this.price);

  get key => null;
  factory Item.fromJson(Map<String, dynamic> json) => Item(
        json['name'] as String,
        json['price'] as double,
      );
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }
}
