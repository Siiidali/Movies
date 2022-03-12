import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/add_movie.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'App',
    theme: ThemeData.dark(),
    home: MyApp(),

    routes: {

      '/addMovies':(context)=>AddPage(),
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title:
            Text('Movies App'),

          leading: IconButton(
            icon: Icon(Icons.add),onPressed: (){
              Navigator.pushNamed(context, '/addMovies');
          },

          )
        ),
        body: MoviesInformation(),
      );
  }
}

class MoviesInformation extends StatefulWidget {
  @override
  _MoviesInformationState createState() => _MoviesInformationState();
}

class _MoviesInformationState extends State<MoviesInformation> {
  final Stream<QuerySnapshot> _moviesStream =
      FirebaseFirestore.instance.collection('Filmes').snapshots();

  void addLike(String docID,int likes){
    var newLikes = likes+1;
    try{
      FirebaseFirestore.instance.collection('Filmes').doc(docID).update({
        'likes': newLikes,
      }).then((value)=>print('Donne à jour'));
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _moviesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> movie =
                document.data()! as Map<String, dynamic>;
            return Padding(padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(width: 100,child: Image.network(movie['poster']),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Year of Porduction: '),
                      Text(movie['year'].toString()),
                      Row(
                        children: [
                          for(final categorie in movie['categories'])
                            Padding(padding: EdgeInsets.only(right: 5),
                            child: Chip(
                              label: Text(categorie),
                              backgroundColor: Colors.lightBlue,
                            ),
                            )
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(padding: EdgeInsets.zero,constraints: BoxConstraints(),iconSize: 20,onPressed: (){addLike(document.id, movie['likes']);}, icon: Icon(Icons.favorite)),
                          Text(movie['likes'].toString())
                        ],
                      )
                    ],
                  ),
                  )
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
