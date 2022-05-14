import 'package:ecommerce_app/styles.dart';
import 'package:ecommerce_app/widgets/bottom_tabs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (value) {
                  setState(() {
                    _selectedTab = value;
                  });
                },
                children: [
                  Container(
                    child: const Center(
                      child: Text("Homepage"),
                    ),
                  ),
                  Container(
                    child: const Center(
                      child: Text("Search Page"),
                    ),
                  ),
                  Container(
                    child: const Center(
                      child: Text("Saved Page"),
                    ),
                  ),
                  Container(
                    child: const Center(
                      child: Text("User Page"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BottomTabs(
            selectedTab: _selectedTab,
            tabPressed: (value) {
              pageController.animateToPage(value,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic);
            },
          ),
        ],
      ),
    );
  }
}
