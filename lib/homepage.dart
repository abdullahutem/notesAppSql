import 'package:flutter/material.dart';
import 'package:learningsql/editenote.dart';
import 'package:learningsql/sqldb.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Sqldb sqldb = Sqldb();
  List notes = [];
  bool isloading = true;

  Future readData() async {
    List<Map> respone = await sqldb.selectData('SELECT * FROM "notes"');
    notes.addAll(respone);
    isloading = false;
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("SQL Lite"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'addnotes');
        },
        child: Icon(Icons.add),
      ),
      body: isloading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView(
                children: [
                  ListView.builder(
                      itemCount: notes.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return Card(
                          child: ListTile(
                              leading: Text("${notes[i]['title']}"),
                              title: Text("${notes[i]['note']}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        // int respone = await sqldb.deleteData(
                                        //     "DELETE  FROM notes WHERE id = ${notes[i]['id']}");
                                        int respone = await sqldb.delete(
                                            'notes', 'id = ${notes[i]['id']}');
                                        if (respone > 0) {
                                          notes.removeWhere((element) =>
                                              element['id'] == notes[i]['id']);
                                          setState(() {});
                                        }
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Editenote(
                                                      id: notes[i]['id'],
                                                      gnote: notes[i]['note'],
                                                      gtitle: notes[i]['title'],
                                                      gcolor: notes[i]['color'],
                                                    )));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blueAccent,
                                      )),
                                ],
                              )),
                        );
                      })
                ],
              ),
            ),
    );
  }
}
