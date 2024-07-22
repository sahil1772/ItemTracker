import 'package:flutter_test/flutter_test.dart';
import 'package:itemtracker/model/Item.dart';
import 'package:itemtracker/providers/ItemNotifier.dart';


void main() {
  group('ItemList', () {
    test('initial items list should be empty', () {
      final itemList = ItemNotifier();
      expect(itemList.items, []);
    });

    test('addItem should add an item to the list', () {
      final itemList = ItemNotifier();
      final item = Item(name: 'Test Name', description: 'Test Description');
      itemList.addItem(item);
      expect(itemList.items, [item]);
    });

    test('removeItem should remove an item from the list', () {
      final itemList = ItemNotifier();
      final item = Item(name: 'Test Name', description: 'Test Description');
      itemList.addItem(item);
      itemList.removeItem(0);
      expect(itemList.items, []);
    });

    test('editItem should edit an item in the list', () {
      final itemList = ItemNotifier();
      final item = Item(name: 'Test Name', description: 'Test Description');
      itemList.addItem(item);
      final editedItem =
          Item(name: 'Edited Name', description: 'Edited Description');
      itemList.editItem(0, editedItem);
      expect(itemList.items, [editedItem]);
    });
  });
}
