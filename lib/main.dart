import 'package:flutter/material.dart';
import 'package:projects/agents.dart';
import 'package:projects/color/color.dart';
import 'package:projects/constants/http.dart';
import 'package:projects/drawer.dart';
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
      theme: ThemeData(
        fontFamily: 'Valorant',
        scaffoldBackgroundColor: bgBlue,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MapPage(),
        '/agents': (context) => const AgentsPage(),
      },
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
  late final Future<List<MapModel>> _mapFuture;

  @override
  void initState() {
    super.initState();
    _mapFuture = _httpClient.getMap();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: bgBlue,
        image: DecorationImage(
          image: AssetImage('assets/images/mapvalbg.png'),
          fit: BoxFit.fill,
          opacity: 0.3,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        drawer: const ValDrawer(currentPage: 'maps'),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 100,
              backgroundColor: Colors.transparent,
              elevation: 0,
              floating: true,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'maps',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: valRed.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/vallogo.png',
                      fit: BoxFit.contain,
                      height: 40,
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: _mapFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<List<MapModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: valRed),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'no maps found',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    ),
                  );
                }
                final maps = snapshot.data!;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      var mapModel = maps[index];
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
                    childCount: maps.length,
                  ),
                );
              },
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
                                    mapDesc ??
                                        "5°26'BF'N,12°20'Q'E",
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
                                    mapDesc ??
                                        "5°41'CD'N,139°41'WX'E",
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
