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
          children: [
            MapListItem(img: 'assets/images/bind.png'),
            MapListItem(img: 'assets/images/bind.png'),
            MapListItem(img: 'assets/images/bind.png'),
          ],
        ),
      ),
    );
  }
}

class MapListItem extends StatelessWidget {
  String img;
  MapListItem({Key? key, required this.img}) : super(key: key);

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
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(img),
                      fit: BoxFit.fill,
                    ),
                    color: Colors.redAccent.withAlpha(160),
                  ),
                  height: 125,
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    height: 125,
                    color: Colors.blueAccent.withAlpha(100),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
