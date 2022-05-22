import 'package:ecommerce_app/services/firebase_services.dart';
import 'package:ecommerce_app/tabs/home_tab.dart';
import 'package:ecommerce_app/tabs/saved_tab.dart';
import 'package:ecommerce_app/tabs/search_tab.dart';
import 'package:ecommerce_app/tabs/user_tab.dart';
import 'package:ecommerce_app/widgets/bottom_tabs.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseServives firebaseServives = FirebaseServives();
  int _selectedTab = 0;
  late PageController pageController;

  @override
  void initState() {
    print("UserId: ${firebaseServives.getUserId()}");
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
                  HomeTab(),
                  SearchTab(),
                  const SavedTab(),
                  const UserTab(),
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
