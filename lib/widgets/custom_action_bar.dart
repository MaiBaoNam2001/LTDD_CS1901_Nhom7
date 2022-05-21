import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/firebase_services.dart';
import 'package:ecommerce_app/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../views/cart_page.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasTitle;
  final bool hasBackground;

  CustomActionBar(
      {required this.title,
      required this.hasBackArrow,
      required this.hasTitle,
      required this.hasBackground});

  FirebaseServives firebaseServives = FirebaseServives();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: hasBackground
            ? LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0),
                ],
                begin: const Alignment(0, 0),
                end: const Alignment(0, 1),
              )
            : null,
      ),
      padding: const EdgeInsets.only(
        top: 56.0,
        left: 24.0,
        right: 24.0,
        bottom: 42.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (hasBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Ionicons.chevron_back,
                  color: Colors.white,
                ),
              ),
            ),
          if (hasTitle)
            Text(
              title,
              style: Styles.boldHeading,
            ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartPage(),
                  ));
            },
            child: Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              child: StreamBuilder<QuerySnapshot>(
                stream: firebaseServives.usersReference
                    .doc(firebaseServives.getUserId())
                    .collection("Cart")
                    .snapshots(),
                builder: (context, snapshot) {
                  int totalItems = 0;

                  if (snapshot.connectionState == ConnectionState.active) {
                    List documents = snapshot.data!.docs;
                    totalItems = documents.length;
                  }
                  return Text(
                    "$totalItems",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
