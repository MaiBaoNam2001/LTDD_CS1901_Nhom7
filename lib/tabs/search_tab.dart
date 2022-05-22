import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/firebase_services.dart';
import 'package:ecommerce_app/styles.dart';
import 'package:ecommerce_app/widgets/custom_input.dart';
import 'package:flutter/material.dart';

import '../widgets/product_card.dart';

class SearchTab extends StatefulWidget {
  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FocusNode focusNode = FocusNode();
  FirebaseServives firebaseServives = FirebaseServives();
  String searchString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (searchString.isEmpty)
            Center(
              child: Container(
                child: const Text(
                  "Search Results",
                  style: Styles.regularDarkText,
                ),
              ),
            )
          else
            FutureBuilder<QuerySnapshot>(
              future: firebaseServives.productsReference
                  .orderBy("search_string")
                  .startAt([searchString]).endAt(["$searchString\uf8ff"]).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    padding: const EdgeInsets.only(
                      top: 128.0,
                      bottom: 12.0,
                    ),
                    children: snapshot.data!.docs.map((document) {
                      return ProductCard(
                          productId: document.id,
                          imageUrl: "${document["images"][0]}",
                          price: "\$${document["price"]}");
                    }).toList(),
                  );
                }
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.only(
              top: 45.0,
            ),
            child: CustomInput(
              hintText: "Search here...",
              onChanged: (value) {},
              onSubmitted: (value) {
                setState(() {
                  searchString = value.toLowerCase();
                });
              },
              focusNode: focusNode,
              isPasswordField: false,
            ),
          ),
        ],
      ),
    );
  }
}
