import 'package:flutter/material.dart';
import 'package:learningsql/homepage.dart';
import 'package:learningsql/sqldb.dart';

class Editenote extends StatefulWidget {
  final gtitle;
  final gnote;
  final gcolor;
  final id;
  const Editenote({super.key, this.gtitle, this.gnote, this.gcolor, this.id});

  @override
  State<Editenote> createState() => _EditenoteState();
}

class _EditenoteState extends State<Editenote> {
  Sqldb sqldb = Sqldb();
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  String? selectedColor;
  @override
  void initState() {
    super.initState();
    note.text = widget.gnote;
    title.text = widget.gtitle;
    selectedColor = widget.gcolor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 143, 92, 11),
        title: const Text("Edit Notes"),
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
//                           String sql = '''
//   UPDATE notes SET
//   note = "${note.text}",
//   title = "${title.text}",
//   color = "${selectedColor.toString()}"
//   WHERE id = ${widget.id}
// ''';

//                            int respone = await sqldb.updateData(sql);
                          int respone = await sqldb.update(
                              'notes',
                              {
                                'note': '${note.text}',
                                'title': '${title.text}',
                                'color': '${selectedColor}',
                              },
                              'id = ${widget.id}');
                          print("====================$respone");
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
                        'Edit Note',
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
