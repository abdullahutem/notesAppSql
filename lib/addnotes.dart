import 'package:flutter/material.dart';
import 'package:learningsql/homepage.dart';
import 'package:learningsql/sqldb.dart';

class Addnotes extends StatefulWidget {
  const Addnotes({super.key});

  @override
  State<Addnotes> createState() => _AddnotesState();
}

class _AddnotesState extends State<Addnotes> {
  Sqldb sqldb = Sqldb();
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  String? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Add Notes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: formstate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: title,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter note title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: note,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Note',
                      hintText: 'Enter your note',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a note';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedColor,
                    decoration: InputDecoration(
                      labelText: 'Select Color',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Red', 'Blue', 'Green', 'Yellow', 'Orange']
                        .map((color) {
                      return DropdownMenuItem<String>(
                        value: color,
                        child: Text(color),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedColor = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a color';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                         if (formstate.currentState!.validate()) {
                        //   String sql =
                        //       "INSERT INTO notes (title, note, color) VALUES ('${title.text}', '${note.text}', '${selectedColor.toString()}')";

                        //   int respone = await sqldb.insertData(sql);
                        int respone = await sqldb.insert('notes', {
                          'note': '${note.text}',
                          'title': '${title.text}',
                          'color': '${selectedColor}',
                        });
                          if (respone > 0) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => Homepage()),
                                (route) => false);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Add Note',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
