import 'package:ecommerce_app/styles.dart';
import 'package:ecommerce_app/views/change_password_page.dart';
import 'package:ecommerce_app/widgets/custom_action_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class UserTab extends StatelessWidget {
  const UserTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Container(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 120.0,
              left: 24.0,
              right: 24.0,
              bottom: 12.0,
            ),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 48.0,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child:
                        const Icon(Ionicons.person_circle_outline, size: 150),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                  ),
                  child: Text(
                    "Email: ${user?.email}",
                    style: Styles.regularDarkText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                  ),
                  child: Text(
                    "User ID: ${user?.uid}",
                    style: Styles.regularDarkText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 48.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordPage(),
                              ),
                            );
                          },
                          child: Container(
                            height: 65.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: const Text(
                              "Change Password",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 16.0,
                          ),
                          width: 65.0,
                          height: 65.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCDCDC),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Icon(Ionicons.log_out_outline),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          CustomActionBar(
            title: "User",
            hasBackArrow: false,
            hasTitle: true,
            hasBackground: true,
          ),
        ],
      ),
    );
  }
}
