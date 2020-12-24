import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food/colors.dart';
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
          title: Text(
            passData.substring(0, 1).toUpperCase() +
                passData.substring(1, passData.indexOf("Category")) +
                " Mutfağı",
            style: TextStyle(fontFamily: 'Berlin Sans FB Regular'),
          ),
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

  int i = 0;
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

    double widtH = MediaQuery.of(context).size.width;

    i++;


    if (i % 2 == 1) {
      double lft = -60.0;

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
              Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(
                          row.colors[0], row.colors[1], row.colors[2], 1),
                    ),
                    child: Center(
                        child: Text(
                      row.name,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: 'Berlin Sans FB Regular'),
                    )),
                  ),
                  Positioned(
                    left: lft,
                    child: Container(
                        height: 120,
                        width: 140,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(row.categoryPhoto),
                                fit: BoxFit.cover))),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (i % 2 == 0) {
      double rght = -60;

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
              Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  Container(
                    height: 120,
                    color: Color.fromRGBO(
                        row.colors[0], row.colors[1], row.colors[2], 1),
                    child: Center(
                        child: Text(
                      row.name,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: 'Berlin Sans FB Regular'),
                    )),
                  ),
                  Positioned(
                    right: rght,
                    child: Container(
                        height: 120,
                        width: 140,

                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(row.categoryPhoto),
                                fit: BoxFit.fill))),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}

class GetCard {
  String categoryPhoto;
  String name;
  var colors;
  DocumentReference reference;

  GetCard.fromMap(Map<dynamic, dynamic> map, {this.reference})
      : assert(map["photo"] != null),
        assert(map["name"] != null),
        categoryPhoto = map["photo"],
        name = map["name"],
        colors = List<int>.from(map['colors']);
  GetCard.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
