import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiselect/multiselect.dart';
class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final nameController = TextEditingController();
  final yearController = TextEditingController();
  final posterController = TextEditingController();
  List<String> catogories = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('Add Movies'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child:Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.white30,width: 1.5),
              ),
              title: Row(
                children: [
                  Text('Name: '),
                  Expanded(child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller: nameController,
                  ),
                  )
                ],
              ),
            ),
            const SizedBox(height:20,),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.white30,width: 1.5),
              ),
              title: Row(
                children: [
                  Text('Year: '),
                  Expanded(child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller: yearController,
                  ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20,),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.white30,width: 1.5),
              ),
              title: Row(
                children: [
                  Text('Poster: '),
                  Expanded(child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller: posterController,
                  ),
                  )
                ],
              ),
            ),
                DropDownMultiSelect(
                onChanged: (List<String> x) {
                      setState(() {
                      catogories =x;
                      });
                      },
                      options: ['action' , 'drama' , 'comidie' , 'romance'],
                      selectedValues: catogories,
                      whenEmpty: 'Categorie',
                      ),
            ElevatedButton(onPressed: (){
              FirebaseFirestore.instance.collection('Filmes').add({
                'name': nameController.value.text,
                'year': yearController.value.text,
                'poster': posterController.value.text,
                'categories': catogories,
                'likes': 0,
              });
              Navigator.pop(context);
            }, child: Text('Add Movie'))
          ],
        )
      ),
    );
  }
}
