import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool formLoading = false;

  String email = "";
  String oldPassword = "";
  String newPassword = "";
  String confirmNewPassword = "";

  late FocusNode oldPasswordFocusNode;
  late FocusNode newPasswordFocusNode;
  late FocusNode confirmNewPasswordFocusNode;

  @override
  initState() {
    oldPasswordFocusNode = FocusNode();
    newPasswordFocusNode = FocusNode();
    confirmNewPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    oldPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmNewPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FloatingActionButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<String> changePassword() async {
    if (newPassword.length < 8) {
      return 'The new password provided is too weak.';
    }
    if (confirmNewPassword.length < 8) {
      return 'The confirmation new password provided is too weak.';
    }
    if (newPassword != confirmNewPassword) {
      return 'The confirmation new password provided is incorrect.';
    }
    try {
      User? user = FirebaseAuth.instance.currentUser;
      email = user!.email.toString();
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: oldPassword);
      user.updatePassword(newPassword);
      return '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  void submitForm() async {
    setState(() {
      formLoading = true;
    });

    String changePasswordFeedback = await changePassword();
    if (changePasswordFeedback != '') {
      alertDialogBuilder(changePasswordFeedback);

      setState(() {
        formLoading = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 24.0),
                child: const Text(
                  "Change Password",
                  textAlign: TextAlign.center,
                  style: Styles.boldHeading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText: "Password",
                    onChanged: (value) {
                      oldPassword = value;
                    },
                    onSubmitted: (value) {
                      newPasswordFocusNode.requestFocus();
                    },
                    focusNode: oldPasswordFocusNode,
                    isPasswordField: true,
                    // textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                    hintText: "New Password",
                    onChanged: (value) {
                      newPassword = value;
                    },
                    onSubmitted: (value) {
                      confirmNewPasswordFocusNode.requestFocus();
                    },
                    focusNode: newPasswordFocusNode,
                    isPasswordField: true,
                    // textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                    hintText: "Confirm New Password",
                    onChanged: (value) {
                      confirmNewPassword = value;
                    },
                    onSubmitted: (value) {},
                    focusNode: confirmNewPasswordFocusNode,
                    isPasswordField: true,
                    // textInputAction: TextInputAction.done,
                  ),
                  CustomButton(
                    text: "Change Password",
                    onPressed: () {
                      submitForm();
                    },
                    outlineButton: false,
                    isLoading: formLoading,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: CustomButton(
                  text: "Back To User",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  outlineButton: true,
                  isLoading: false,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
