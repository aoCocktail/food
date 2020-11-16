import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'category_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'food mood',
            style: TextStyle(fontFamily: 'Berlin Sans FB Regular'),
          ),
        ),
        body: CreateCard(),
      ),
    );
  }
}

class CreateCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateCardState();
  }
}

class CreateCardState extends State {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("countries")
          .orderBy('name', descending: false)
          .snapshots(),
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
      children:
          snapshot.map<Widget>((data) => buildListItem(context, data)).toList(),
    );
  }

  buildListItem(BuildContext context, DocumentSnapshot data) {
    final row = GetCard.fromSnapshot(data);

    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return ExpandableNotifier(
        child: Card(
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailPage(passData: row.reference.documentID)),
        ),
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
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                  collapseIcon: Icons.fastfood,
                ),
                header: Text(
                  row.name,
                  style: TextStyle(
                      fontSize: 22, fontFamily: 'Berlin Sans FB Regular'),
                  textAlign: TextAlign.center,
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.definition,
                      style: TextStyle(fontSize: 17),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class GetCard {
  String photo;
  String name;
  String definition;
  DocumentReference reference;

  GetCard.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map["photo"] != null),
        assert(map["name"] != null),
        assert(map["definition"] != null),
        photo = map["photo"],
        definition = map["definition"],
        name = map["name"];

  GetCard.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
