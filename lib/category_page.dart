import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';

import 'package:flutter/material.dart';
import 'package:food/food_page.dart';

void main() => runApp(MaterialApp());

class DetailPage extends StatelessWidget {
  String passData;
  DetailPage({Key key, @required this.passData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(passData.substring(0, 1).toUpperCase() +
              passData.substring(1, passData.length)),
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
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  // ignore: deprecated_member_use
                  FoodPage(passData: row.reference.documentID)),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(row.categoryPhoto),
                        fit: BoxFit.cover)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GetCard {
  String categoryPhoto;

  DocumentReference reference;

  GetCard.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map["photo"] != null),
        categoryPhoto = map["photo"];

  GetCard.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
