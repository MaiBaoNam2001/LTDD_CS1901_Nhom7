import 'package:ecommerce_app/styles.dart';
import 'package:ecommerce_app/views/home_page.dart';
import 'package:ecommerce_app/views/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> initialization = Firebase.initializeApp();

  LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ),
                );
              }
              if (streamSnapshot.connectionState == ConnectionState.active) {
                // User user = streamSnapshot.data as User;
                // if (user == null) {
                //   return const LoginPage();
                // } else {
                //   return const HomePage();
                // }
                if (streamSnapshot.hasData) {
                  return const HomePage();
                } else {
                  return const LoginPage();
                }
              }
              return const Scaffold(
                body: Center(
                  child: Text(
                    "Checking Authentication...",
                    style: Styles.regularHeading,
                  ),
                ),
              );
            },
          );
        }
        return const Scaffold(
          body: Center(
            child: Text(
              "Initialization App...",
              style: Styles.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
