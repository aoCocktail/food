import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food/colors.dart';

void main() => runApp(MaterialApp());

class FoodDetail extends StatelessWidget {
  String passData;
  String passDataName;
  int passColor1;
  int passColor2;
  int passColor3;

  FoodDetail(
      {Key key,
        @required this.passData,
        @required this.passDataName,
        @required this.passColor1,
        @required this.passColor2,
        @required this.passColor3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            passDataName.substring(0, 1).toUpperCase() +
                passDataName.substring(1, passDataName.length),
            style: TextStyle(
                fontFamily: 'Berlin Sans FB Regular',
                color: Color.fromRGBO(passColor1, passColor2, passColor3, 1)),
          ),
          leading: BackButton(
            color: Colors.grey,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: CreateCards(
            passData: passData,
            passDataName: passDataName,
            passColor1: passColor1,
            passColor2: passColor2,
            passColor3: passColor3),
      ),
    );
  }
}

class CreateCards extends StatefulWidget {
  String passData, passDataName;
  int passColor1, passColor2, passColor3;
  CreateCards(
      {Key key,
        @required this.passData,
        @required this.passDataName,
        @required this.passColor1,
        @required this.passColor2,
        @required this.passColor3})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreateCardsState(
        passData: this.passData,
        passDataName: this.passDataName,
        passColor1: this.passColor1,
        passColor2: this.passColor2,
        passColor3: this.passColor3);
  }
}

class CreateCardsState extends State<CreateCards> {
  String passData, passDataName;
  int passColor1, passColor2, passColor3;
  CreateCardsState(
      {Key key,
        @required this.passData,
        @required this.passDataName,
        @required this.passColor1,
        @required this.passColor2,
        @required this.passColor3});

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
    double heightH = MediaQuery.of(context).size.height / 3;
    double widthH = MediaQuery.of(context).size.width;
    const double leftPadding = 20.0;

    List<String> nutritionList = ['Kalori', 'Karbonhidrat', 'Yağ', 'Protein'];

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: leftPadding),
                      child: Container(
                        height: heightH - leftPadding,
                        width: widthH - leftPadding,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Besin Degerleri',
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Color.fromRGBO(
                                  passColor1, passColor2, passColor3, 1),
                              fontFamily: 'Berlin Sans FB Regular'),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      top: 20,
                      child: Container(
                          width: widthH / 2,
                          height: widthH / 2,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(row.photo),
                                  fit: BoxFit.fill))),
                    ),
                    Positioned(
                      top: 50,
                      left: 10,
                      child: Container(
                        width: 125,
                        height: heightH,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: nutritionList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  height: heightH / 6,
                                  child: Text(
                                    nutritionList[index],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20.0),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: widthH / 3.2,
                      child: Container(
                        alignment: Alignment.center,
                        width: 55,
                        height: heightH,
                        child: ListView.builder(
                            itemCount: row.nutritions.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  height: heightH / 6,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Color.fromRGBO(
                                          passColor1, passColor2, passColor3, 1)),
                                  child: Center(
                                    child: Text(
                                      row.nutritions[index],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
          Column(
            children: [
              Text(
                'Malzemeler',
                style: TextStyle(
                    fontSize: 28.0,
                    color: Color.fromRGBO(passColor1, passColor2, passColor3, 1),
                    fontFamily: 'Berlin Sans FB Regular'),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 14),
                child: Container(

                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: row.ingredients.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(1.3),
                          child: new Text(
                            '• ' + row.ingredients[index],
                            style: TextStyle(fontSize: 28),
                          ),
                        );
                      }),
                ),
              ),
              Text(
                'Yapılısı',
                style: TextStyle(
                    fontSize: 28.0,
                    color: Color.fromRGBO(passColor1, passColor2, passColor3, 1),
                    fontFamily: 'Berlin Sans FB Regular'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GetCard {
  String photo;
  String name;
  var ingredients, nutritions;

  DocumentReference reference;

  GetCard.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map["photo"] != null),
        assert(map["name"] != null),
        photo = map["photo"],
        name = map["name"],
        ingredients = List<String>.from(map['ingredients']),
        nutritions = List<String>.from(map['nutritions']);

  GetCard.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
