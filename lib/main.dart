import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Yemek"),
        ),
        body: CreateCard(),
      ),
    );
  }
}

class CreateCard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CreateCardState();
  }
}

class CreateCardState extends State{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("food").snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return LinearProgressIndicator();
        }else{
          return buildBody(context, snapshot.data.documents);
        }
      },
    );


  }
  Widget buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top: 20.0),
      children: snapshot.map<Widget> ((data) => buildListItem(context,data)).toList(),
    );
  }

  buildListItem(BuildContext context, DocumentSnapshot data) {
    final row = GetCard.fromSnapshot(data);
    return Padding(
      key: ValueKey(row.name),
      padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(),
        child: Column(children: [
               Container(
                  constraints: BoxConstraints.tightForFinite(
                      width: 400
                  ),
                  height: 200.0,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: NetworkImage(row.photo),
                          fit: BoxFit.fill))),
          SizedBox(height: 7.0),
        ]))
    );
  }
}

class GetCard {
  String name;
  String photo;
  DocumentReference reference;

  GetCard.fromMap(Map<String,dynamic> map, {this.reference})
      :assert(map["name"]!=null), assert(map["photo"]!=null),
        name = map["name"], photo = map["photo"];

  GetCard.fromSnapshot(DocumentSnapshot snapshot)
      :this.fromMap(snapshot.data(), reference:snapshot.reference);
}

