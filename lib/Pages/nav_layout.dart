import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymsystem/constants.dart';
import 'package:gymsystem/controller/main_controller.dart';

import '../widget/navigation_drawer.dart';
import 'member_page.dart';
import 'score_page.dart';
import 'staff_page.dart';

class NavigationLayout extends StatefulWidget {
  const NavigationLayout({super.key});

  @override
  _NavigationLayoutState createState() => _NavigationLayoutState();
}

class _NavigationLayoutState extends State<NavigationLayout> {
  int _selectedIndex = 0;
  MainController mainController = Get.find<MainController>();

  @override
  void initState() {
    super.initState();
    startListeningCard(mainController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavDrawer(onItemSelected: _onNavigationItemSelected),
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: NavDrawer(onItemSelected: _onNavigationItemSelected),
          ),
          Flexible(
            flex: 22,
            child: _buildBody(),
          ),
        ],
      ),

      // drawer: NavDrawer(onItemSelected: _onNavigationItemSelected),
    );
  }

  void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const StaffsPage();
      case 1:
        return const MembersPage();
      case 2: // Index for the ScorePage
        return const ScorePage();
      default:
        return Container();
    }
  }
}
