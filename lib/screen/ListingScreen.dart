import 'package:flutter/material.dart';
import 'package:itemtracker/model/Item.dart';
import 'package:itemtracker/providers/ItemNotifier.dart';
import 'package:provider/provider.dart';

class ListingScreen extends StatelessWidget {
  const ListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<GlobalKey> keys = [];

    ItemNotifier notifier = Provider.of<ItemNotifier>(context,listen: true);

   notifier.items.forEach((element) {
     keys.add(GlobalKey());
   });

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      floatingActionButton: FloatingActionButton(
        key: Key('addItemButton'),
        onPressed: () {
          _showSheet(context: context,onSubmit: (item) {
            notifier.addItem(item);
          });
        },
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Item Tracker",
          style: TextStyle(color: Colors.white),
        ),

      ),
      body: notifier.items.isEmpty
          ? const Center(
              child: Text("No Items Found"),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                final Item item = notifier!.items[index];
                return InkWell(
                  onTap: () {
                    RenderObject? renderObject = keys[index].currentContext!.findRenderObject();
                    if (renderObject is RenderBox) {
                      RenderBox renderBox = renderObject;
                      final size = renderBox.size;
                      final position = renderBox.localToGlobal(Offset.zero);

                      //PRINT SIZE AND POSITION
                      print('Size: $size, Position: $position');
                    }

                  },
                  child: Card(
                    key: keys[index],
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Item Name",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.deepPurple),
                                    ),
                                  ],
                                )),
                                Row(
                                  children: [
                                    OutlinedButton.icon(
                                      key: Key("editButton_$index"),
                                      style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 16,
                                      ),
                                      onPressed: () {
                                        _showSheet(context: context,
                                            onSubmit: (item) {
                                              notifier.editItem(index, item);
                                            },
                                            isEdit: true,
                                            data: item);
                                      },
                                      label: const Text("Edit"),
                                    ),
                                    IconButton(
                                        key: Key("deleteButton_$index"),
                                        onPressed: () {
                                          _showDeleteDialog(context: context,onSubmit: () {
                                            notifier.removeItem(index);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ))
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Description",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    item.description,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.deepPurple),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                );
              },
              itemCount: notifier!.items.length,
              shrinkWrap: true,
            ),
    );
  }

  void _showSheet(
      {required BuildContext context,required Function(Item item) onSubmit,
      bool? isEdit = false,
      Item? data}) {
    final TextEditingController nameController =
        TextEditingController(text: isEdit! ? data!.name : "");
    final TextEditingController descriptionController =
        TextEditingController(text: isEdit! ? data!.description : "");

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Wrap(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Add Item")),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Name",
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder()),
                          controller: nameController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Description",
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder()),
                          controller: descriptionController,
                        ),
                      ),
                      Container(
                        height: 56,
                        margin: const EdgeInsets.all(16),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                onSubmit(Item(
                                    name: nameController.text,
                                    description: descriptionController.text));
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog({required BuildContext context,required Null Function() onSubmit}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("Do you want to delete this item?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.deepPurple),
                )),
            ElevatedButton(
                key: const Key("delete_yes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  Navigator.of(context).pop();
                  onSubmit();
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        );
      },
    );
  }
}
