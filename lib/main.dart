import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:projects/agents.dart';
import 'package:projects/color/color.dart';
import 'package:projects/constants/http.dart';
import 'package:projects/map/map_http_client.dart';
import 'package:projects/model/map.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valorant Stats',
      theme: ThemeData(fontFamily: 'Valorant'),
      home: const MapPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _httpClient = MapHttpClient(mapUrl);

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
        drawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: Drawer(
            child: Stack(
              children: <Widget>[
                BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: bgBlue.withValues(alpha: 0.1)))),
                ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const DrawerHeader(
                        child: Text(
                      "Valorant",
                      style: TextStyle(color: Colors.white),
                    )),
                    ListTile(
                        leading: const Icon(
                          Icons.dashboard,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Maps",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {}),
                    ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Agents",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AgentsPage()));
                        }),
                    ListTile(
                        leading: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Arsenal",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {}),
                  ],
                )
              ],
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 100,
              backgroundColor: Colors.transparent,
              elevation: 0,
              floating: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'maps',
                        style: TextStyle(fontSize: 25),
                      )),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withValues(alpha: 30 / 255),
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
            FutureBuilder(
              future: _httpClient.getMap(),
              builder: (BuildContext context,
                      AsyncSnapshot<List<MapModel>> model) =>
                  model.hasData
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              var mapModel = model.data![index];
                              return index.isOdd
                                  ? EvenMapListItem(
                                      img: mapModel.splash,
                                      mapName: mapModel.displayName,
                                      index: index + 1,
                                      mapDesc: mapModel.coordinates,
                                    )
                                  : OddMapListItem(
                                      img: mapModel.splash,
                                      mapName: mapModel.displayName,
                                      index: index + 1,
                                      mapDesc: mapModel.coordinates,
                                    );
                            },
                            childCount: model.data!.length,
                          ),
                        )
                      : const SliverToBoxAdapter(child: Text('No data found')),
            ),
          ],
        ),
      ),
    );
  }
}

String indexer(int index) {
  return index.toString().padLeft(2, '0');
}

class OddMapListItem extends StatelessWidget {
  final String img;
  final String mapName;
  final String? mapDesc;
  final int index;

  const OddMapListItem(
      {super.key,
      required this.img,
      required this.mapName,
      this.mapDesc,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Row(
            children: [
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
                        image: NetworkImage(img),
                        fit: BoxFit.fill,
                      ),
                    ),
                    height: 125,
                  ),
                ),
              ),
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
              Flexible(
                flex: 8,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Material(
                          clipBehavior: Clip.antiAlias,
                          shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20)),
                          ),
                          color: const Color.fromRGBO(112, 118, 115, 1)
                              .withValues(alpha: 160 / 255),
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
                                    mapDesc ?? "5°26'BF'N,12°20'Q'E",
                                    style: const TextStyle(
                                      fontSize: 12,
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
                            indexer(index),
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

class EvenMapListItem extends StatelessWidget {
  final String img;
  final String mapName;
  final String? mapDesc;
  final int index;

  const EvenMapListItem(
      {super.key,
      required this.img,
      required this.mapName,
      this.mapDesc,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Row(
            children: [
              Flexible(
                flex: 7,
                child: Container(
                  height: 125,
                  color: Colors.transparent,
                ),
              ),
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
                        image: NetworkImage(img),
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
              Flexible(
                flex: 8,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Material(
                          clipBehavior: Clip.antiAlias,
                          shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20)),
                          ),
                          color: const Color.fromRGBO(112, 118, 115, 1)
                              .withValues(alpha: 160 / 255),
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
                                    mapDesc ?? "5°41'CD'N,139°41'WX'E",
                                    style: const TextStyle(
                                      fontSize: 12,
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
                            indexer(index),
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
