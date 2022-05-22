import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/firebase_services.dart';
import 'package:ecommerce_app/styles.dart';
import 'package:ecommerce_app/widgets/custom_action_bar.dart';
import 'package:ecommerce_app/widgets/image_swipe.dart';
import 'package:ecommerce_app/widgets/product_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  const ProductPage({required this.productId});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServives firebaseServives = FirebaseServives();

  final SnackBar snackBarCart =
      const SnackBar(content: Text("Product added to cart"));
  final SnackBar snackBarSaved =
      const SnackBar(content: Text("Product added to saved"));

  String selectProductSize = "S";

  Future addToCart() {
    return firebaseServives.usersReference
        .doc(firebaseServives.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set({"size": selectProductSize});
  }

  Future addToSaved() {
    return firebaseServives.usersReference
        .doc(firebaseServives.getUserId())
        .collection("Saved")
        .doc(widget.productId)
        .set({"size": selectProductSize});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future:
                firebaseServives.productsReference.doc(widget.productId).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                DocumentSnapshot documentData =
                    snapshot.data as DocumentSnapshot;

                List imageList = documentData["images"];
                List selectSizeList = documentData["size"];

                selectProductSize = selectSizeList[0];

                return ListView(
                  children: [
                    ImageSwipe(imageList: imageList),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 28.0,
                        left: 24.0,
                        right: 24.0,
                        bottom: 4.0,
                      ),
                      child: Text(
                        "${documentData["name"]}",
                        style: Styles.boldHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "\$${documentData["price"]}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "${documentData["description"]}",
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "Select Size",
                        style: Styles.regularDarkText,
                      ),
                    ),
                    ProductSize(
                      selectSizeList: selectSizeList,
                      onSelected: (size) {
                        selectProductSize = size;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 42.0,
                        left: 24.0,
                        right: 24.0,
                        bottom: 24.0,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await addToSaved();
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBarSaved);
                            },
                            child: Container(
                              width: 65.0,
                              height: 65.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCDCDC),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const Icon(Ionicons.bookmark_outline),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await addToCart();
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBarCart);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 16.0,
                                ),
                                height: 65.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: const Text(
                                  "Add To Cart",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
            title: "",
            hasBackArrow: true,
            hasTitle: false,
            hasBackground: false,
          )
        ],
      ),
    );
  }
}
