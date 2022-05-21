import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/views/product_page.dart';
import 'package:ecommerce_app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_action_bar.dart';

class HomeTab extends StatelessWidget {
  final Query productsReference =
      FirebaseFirestore.instance.collection("Products").orderBy("price");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: productsReference.get(),
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
                    top: 108.0,
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
          CustomActionBar(
            title: 'Home',
            hasBackArrow: false,
            hasTitle: true,
            hasBackground: true,
          ),
        ],
      ),
    );
  }
}
