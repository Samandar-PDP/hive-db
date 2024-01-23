import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_practice/book.dart';
import 'package:hive_practice/box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _title = TextEditingController();
  final _author = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive DB"),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Books>('books_box').listenable(),
        builder: (context, Box<Books> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text("No Books"));
          } else {
            return ListView.separated(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                var result = box.getAt(index);

                return Card(
                  child: ListTile(
                    title: Text(result?.bookTitle ?? ""),
                    subtitle: Text(result?.bookAuthor ?? ""),
                    trailing: InkWell(
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                      onTap: () {
                        box.deleteAt(index);
                      },
                    ),
                  ),
                );
              },
              separatorBuilder: (context, i) {
                return const SizedBox(height: 12);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => addNewBook(context),
      ),
    );
  }

  addNewBook(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("New book"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _author,
                  decoration: const InputDecoration(hintText: 'Author'),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () async {
                      await box?.put(
                          DateTime.now().toString(),
                          Books(
                            bookTitle: _title.text,
                            bookAuthor: _author.text,
                          ));
                      Navigator.pop(context);
                    },
                    child: const Text("Add")),
              ],
            ),
          );
        });
  }
}