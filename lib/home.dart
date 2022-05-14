import 'package:flutter/material.dart';
import 'package:todo/database/notes_database.dart';
import 'model/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myController = TextEditingController();
  final _todo = NotesDatabase();
  int id = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('My todo!'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Note>?>(
              future: _todo.todos(),
              builder: (context, AsyncSnapshot<List<Note>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: const Color(0xFF2D6E7E),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data![index].text,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  )
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 12.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFB945),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      await _todo.deleteTodo(snapshot.data![index].id);
                                      setState(() {});
                                    }, 
                                    icon: const Icon(
                                      Icons.delete, 
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  }
                  return const Center(
                    child: Text(
                      'No notes yet',
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFC6DE41),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: myController,
                    cursorColor: const Color(0xFFC6DE41),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Type a new Task...',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    final text = myController.value.text;
                    if (text.isEmpty) {
                      return;
                    }

                    final Note model = Note(text: text, id: id++);
                    await _todo.addTodo((model));
                    setState(() {
                      FocusScope.of(context).unfocus();
                      myController.clear();
                    });
                  },
                  child: const Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    primary: const Color(0xFF2D6E7E),
                    minimumSize: const Size(50, 50),
                    shape: const CircleBorder()
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}