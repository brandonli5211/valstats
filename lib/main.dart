import 'package:flutter/material.dart';
import 'package:projects/color/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valorant Stats',
      theme: ThemeData(fontFamily: 'Valorant'),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: bgBlue,
          image: DecorationImage(
              image: AssetImage('assets/images/mapvalbg.png'),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('valorant')),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withAlpha(35),
                        blurRadius: 4.2,
                      ),
                    ]),
                child: Image.asset(
                  'assets/images/vallogo.png',
                  fit: BoxFit.contain,
                  height: 45,
                ),
              ),
            ],
          ),
        ),
        body: ListView(
          children: const [
            OddMapListItem(
              img: 'assets/images/maps/bind.png',
              mapName: "Bind",
              index: 1,
            ),
            EvenMapListItem(
              img: 'assets/images/maps/haven.png',
              mapName: "Haven",
              index: 2,
            ),
            OddMapListItem(
              img: 'assets/images/maps/ascent.png',
              mapName: "Ascent",
              index: 3,
            ),
            EvenMapListItem(
              img: 'assets/images/maps/split.png',
              mapName: "Split",
              index: 4,
            ),
          ],
        ),
      ),
    );
  }
}

// different orientation based on position in the list order
class OddMapListItem extends StatelessWidget {
  final String img;
  final String mapName;
  final String? mapDesc;
  final int? index;

  const OddMapListItem(
      {Key? key,
      required this.img,
      required this.mapName,
      this.mapDesc,
      this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Row(
            children: [
              //image flexible
              Flexible(
                flex: 11,
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                  )),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(img),
                        fit: BoxFit.fill,
                      ),
                    ),
                    height: 125,
                  ),
                ),
              ),

              // invisible flexible for stacking
              Flexible(
                flex: 7,
                child: Container(
                  height: 125,
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 9,
                child: Container(
                  height: 125,
                  color: Colors.transparent,
                ),
              ),

              // invisible flexible for stacking
              Flexible(
                flex: 8,
                child: Stack(
                  children: [
                    // container for stacking the index
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Material(
                          clipBehavior: Clip.antiAlias,
                          shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20)),
                          ),
                          color: const Color.fromRGBO(112, 118, 115, 1)
                              .withAlpha(160),
                          child: SizedBox(
                            height: 125,
                            width: 375,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, left: 13.0, right: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mapName,
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    mapDesc ??
                                        "Two sites. No middle. Gotta pick left or right. "
                                            "What’s it going to be then? Both offer direct paths "
                                            "for attackers and a pair of one-way teleporters make "
                                            "it easier to flank.",
                                    style: const TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(132, 138, 138, 1),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 8,
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                    Positioned(
                        top: 4,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            "0$index",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// different orientation based on position in the list order
class EvenMapListItem extends StatelessWidget {
  //img path
  final String img;
  final String mapName;
  final String? mapDesc;
  final int? index;

  const EvenMapListItem(
      {Key? key,
      required this.img,
      required this.mapName,
      this.mapDesc,
      this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Row(
            children: [
              // invisible flexible for stacking
              Flexible(
                flex: 7,
                child: Container(
                  height: 125,
                  color: Colors.transparent,
                ),
              ),

              //image flexible
              Flexible(
                flex: 11,
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                  )),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(img),
                        fit: BoxFit.fill,
                      ),
                    ),
                    height: 125,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              // invisible flexible for stacking
              Flexible(
                flex: 8,
                child: Stack(
                  children: [
                    // container for stacking the index
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Material(
                          clipBehavior: Clip.antiAlias,
                          shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20)),
                          ),
                          color: const Color.fromRGBO(112, 118, 115, 1)
                              .withAlpha(160),
                          child: SizedBox(
                            height: 125,
                            width: 375,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, left: 13.0, right: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mapName,
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    mapDesc ??
                                        "Two sites. No middle. Gotta pick left or right. "
                                            "What’s it going to be then? Both offer direct paths "
                                            "for attackers and a pair of one-way teleporters make "
                                            "it easier to flank.",
                                    style: const TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(132, 138, 138, 1),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 8,
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                    Positioned(
                        top: 4,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            "0$index",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        )),
                  ],
                ),
              ),
              Flexible(
                flex: 9,
                child: Container(
                  height: 125,
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
