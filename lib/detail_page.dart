import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() => runApp(MaterialApp());

// ignore: must_be_immutable
class DetailPage extends StatelessWidget {
  String passData;
  DetailPage({Key key, @required this.passData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Detay"),
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: CreateCards(passData: passData),
      ),
    );
  }
}

class CreateCards extends StatefulWidget {
  String passData;
  CreateCards({Key key, @required this.passData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreateCardsState(passData);
  }
}

class CreateCardsState extends State<CreateCards> {
  String passData;
  CreateCardsState(this.passData);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(passData).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return buildBody(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top: 20.0),
      children:
      snapshot.map<Widget>((data) => buildListItem(context, data)).toList(),
    );
  }

  buildListItem(BuildContext context, DocumentSnapshot data) {
    final row = GetCard.fromSnapshot(data);

    return Padding(
      key: ValueKey(row.name),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(children: [
        Container(
            constraints: BoxConstraints.tightForFinite(width: 400),
            height: 200.0,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: NetworkImage(row.photo), fit: BoxFit.fill))),
        SizedBox(height: 7.0),
      ]),
    );
  }
}

class GetCard {
  String name;
  String photo;
  DocumentReference reference;

  GetCard.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map["name"] != null),
        assert(map["photo"] != null),
        name = map["name"],
        photo = map["photo"];

  GetCard.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}