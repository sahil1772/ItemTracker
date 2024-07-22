import 'package:flutter/material.dart';
import 'package:itemtracker/model/Item.dart';

class ItemNotifier with ChangeNotifier {
  //Initializing private array of [Item.dart]
  List<Item> _items = [];

  //Setting getter for List of Items
  List<Item> get items {
    return _items;
  }

  //Created a insertion method
  addItem(Item newItem){
    //Add Item to _item array
    _items.add(newItem);
    //Notify Consumers that data has changed
    notifyListeners();
  }

  //Created a deletion method
  removeItem(int indexToDelete){
    //Remove Item From _item array
    _items.removeAt(indexToDelete);

    notifyListeners();
  }

  //Create a edit method
  editItem(int positionToUpdate,Item editedItem){
    //Fetch Item by Index and Update
    _items[positionToUpdate] = editedItem;
    //Notify Consumers that data has changed
    notifyListeners();

  }

}
