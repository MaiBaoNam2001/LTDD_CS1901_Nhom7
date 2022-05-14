import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class BottomTabs extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;

  const BottomTabs({required this.selectedTab, required this.tabPressed});

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    _selectedTab = widget.selectedTab ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1.0,
            blurRadius: 30.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabButton(
            iconData: Ionicons.home_outline,
            isSelected: _selectedTab == 0 ? true : false,
            onPressed: () {
              widget.tabPressed(0);
            },
          ),
          BottomTabButton(
            iconData: Ionicons.search_outline,
            isSelected: _selectedTab == 1 ? true : false,
            onPressed: () {
              setState(() {
                widget.tabPressed(1);
              });
            },
          ),
          BottomTabButton(
            iconData: Ionicons.bookmark_outline,
            isSelected: _selectedTab == 2 ? true : false,
            onPressed: () {
              setState(() {
                widget.tabPressed(2);
              });
            },
          ),
          BottomTabButton(
            iconData: Ionicons.person_outline,
            isSelected: _selectedTab == 3 ? true : false,
            onPressed: () {
              setState(() {
                widget.tabPressed(3);
              });
            },
          ),
        ],
      ),
    );
  }
}

class BottomTabButton extends StatelessWidget {
  final IconData iconData;
  final bool isSelected;
  final VoidCallback onPressed;

  const BottomTabButton(
      {required this.iconData,
      required this.isSelected,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 22.0,
          horizontal: 24.0,
        ),
        child: Icon(iconData,
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Colors.black),
      ),
    );
  }
}
