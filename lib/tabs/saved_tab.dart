import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import '../views/product_page.dart';
import '../widgets/custom_action_bar.dart';

class SavedTab extends StatelessWidget {
  const SavedTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServives firebaseServives = FirebaseServives();

    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: firebaseServives.usersReference
                .doc(firebaseServives.getUserId())
                .collection("Saved")
                .get(),
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductPage(productId: document.id),
                          ),
                        );
                      },
                      child: FutureBuilder(
                        future: firebaseServives.productsReference
                            .doc(document.id)
                            .get(),
                        builder: (context, productSnapshot) {
                          if (productSnapshot.hasError) {
                            return Container(
                              child: Center(
                                child: Text("Error: ${productSnapshot.error}"),
                              ),
                            );
                          }
                          if (productSnapshot.connectionState ==
                              ConnectionState.done) {
                            DocumentSnapshot productMap =
                                productSnapshot.data as DocumentSnapshot;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 90.0,
                                    height: 90.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        "${productMap["images"][0]}",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: 16.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${productMap["name"]}",
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: Text(
                                            "\$${productMap["price"]}",
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.deepOrangeAccent,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Size: ${document["size"]}",
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container(
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    );
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
            title: 'Saved',
            hasBackArrow: false,
            hasTitle: true,
            hasBackground: true,
          ),
        ],
      ),
    );
  }
}
