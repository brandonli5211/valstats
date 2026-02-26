import 'package:flutter/material.dart';
import 'package:projects/color/color.dart';
import 'package:projects/drawer.dart';

class AgentsPage extends StatelessWidget {
  const AgentsPage({super.key});

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
        drawer: const ValDrawer(currentPage: 'agents'),
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
                    'agents',
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
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'coming soon',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
