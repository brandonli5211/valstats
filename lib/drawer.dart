import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:projects/color/color.dart';

class ValDrawer extends StatelessWidget {
  final String currentPage;

  const ValDrawer({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: Drawer(
        child: Stack(
          children: <Widget>[
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: bgBlue.withValues(alpha: 0.85),
                ),
              ),
            ),
            Column(
              children: [
                _buildHeader(),
                const Divider(color: valRed, thickness: 1, height: 1),
                const SizedBox(height: 12),
                _buildTile(
                  context,
                  icon: Icons.map_outlined,
                  label: "maps",
                  route: 'maps',
                ),
                _buildTile(
                  context,
                  icon: Icons.people_outline,
                  label: "agents",
                  route: 'agents',
                ),
                _buildTile(
                  context,
                  icon: Icons.shield_outlined,
                  label: "arsenal",
                  route: 'arsenal',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Row(
          children: [
            Image.asset(
              'assets/images/vallogo.png',
              height: 36,
            ),
            const SizedBox(width: 14),
            const Text(
              "valorant",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    final isActive = currentPage == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: isActive ? valRed.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          leading: Icon(
            icon,
            color: isActive ? valRed : Colors.white70,
            size: 22,
          ),
          title: Text(
            label,
            style: TextStyle(
              color: isActive ? valRed : Colors.white,
              fontSize: 15,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              letterSpacing: 1.5,
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onTap: () {
            if (isActive) {
              Navigator.pop(context);
              return;
            }
            Navigator.pop(context);
            if (route == 'maps') {
              Navigator.pushReplacementNamed(context, '/');
            } else if (route == 'agents') {
              Navigator.pushReplacementNamed(context, '/agents');
            }
          },
        ),
      ),
    );
  }
}
