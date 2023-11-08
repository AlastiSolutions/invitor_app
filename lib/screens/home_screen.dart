import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invitor_app/widgets/global/bottom_nav_bar.dart';
import 'package:invitor_app/widgets/global/start_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/home/add_calendar');
            },
          ),
        ],
      ),
      drawer: const StartDrawer(),
      bottomNavigationBar: const BottomNavBar(index: 0),
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        decoration: const BoxDecoration(color: Colors.blue),
      ),
    );
  }
}
