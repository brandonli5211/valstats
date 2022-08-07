import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:projects/main.dart';

import 'color/color.dart';

class AgentsPage extends StatelessWidget {
  const AgentsPage({Key? key}) : super(key: key);

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
                    //this is dependent on the import statment above
                    child: Container(
                        decoration:
                            BoxDecoration(color: bgBlue.withOpacity(0.1)))),
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
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MapPage()));
                        }),
                    ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Agents",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {}),
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
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 100,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          'Agents',
                          style: TextStyle(fontSize: 25),
                        )),
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
              )
            ];
          },
          body: Column(
            children: [
              Container(
                height: 600,
                color: Colors.redAccent,
              ),
              Container(
                height: 1000,
                color: Colors.blueAccent,
              )
            ],
          ),
        ),
      ),
    );
  }
}
