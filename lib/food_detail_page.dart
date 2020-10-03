import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp());

class FoodDetail extends StatelessWidget {
  String passData;
  String passDataName;
  FoodDetail({Key key, @required this.passData, @required this.passDataName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(passDataName.substring(0, 1).toUpperCase() +
              passDataName.substring(1, passDataName.length)),
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: CreateCards(passData: passData, passDataName: passDataName),
      ),
    );
  }
}

class CreateCards extends StatefulWidget {
  String passData, passDataName;
  CreateCards({Key key, @required this.passData, @required this.passDataName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreateCardsState(
        passData: this.passData, passDataName: this.passDataName);
  }
}

class CreateCardsState extends State<CreateCards> {
  String passData;
  String passDataName;
  CreateCardsState(
      {Key key, @required this.passData, @required this.passDataName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(passData)
          .where('name', isEqualTo: passDataName)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          // ignore: deprecated_member_use
          return buildBody(context, snapshot.data.docs);
        }
      },
    );
  }

  Widget buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children:
          snapshot.map<Widget>((data) => buildListItem(context, data)).toList(),
    );
  }

  buildListItem(BuildContext context, DocumentSnapshot data) {
    final row = GetCard.fromSnapshot(data);

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(row.photo), fit: BoxFit.cover)),
            ),
          ),
        ],
      ),
    );
  }
}

class GetCard {
  String photo;
  String name;
  DocumentReference reference;

  GetCard.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map["photo"] != null),
        assert(map["name"] != null),
        photo = map["photo"],
        name = map["name"];

  GetCard.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}