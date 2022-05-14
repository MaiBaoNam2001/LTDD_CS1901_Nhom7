import 'package:ecommerce_app/styles.dart';
import 'package:ecommerce_app/views/register_page.dart';
import 'package:ecommerce_app/widgets/custom_button.dart';
import 'package:ecommerce_app/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginEmail = "";
  String loginPassword = "";
  bool loginFormLoading = false;

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

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

  Future<String> loginAccount() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginEmail, password: loginPassword);
      return '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
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
      loginFormLoading = true;
    });

    String loginAccountFeedback = await loginAccount();
    if (loginAccountFeedback != '') {
      alertDialogBuilder(loginAccountFeedback);

      setState(() {
        loginFormLoading = false;
      });
    }
    // else {
    //   Navigator.pop(context);
    // }
  }

  @override
  void initState() {
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
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
                  "Welcome User, \nLogin To Your Account",
                  textAlign: TextAlign.center,
                  style: Styles.boldHeading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText: "Email",
                    onChanged: (value) {
                      loginEmail = value;
                    },
                    onSubmitted: (value) {
                      passwordFocusNode.requestFocus();
                    },
                    focusNode: emailFocusNode,
                    isPasswordField: false,
                    // textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                    hintText: "Password",
                    onChanged: (value) {
                      loginPassword = value;
                    },
                    onSubmitted: (value) {},
                    focusNode: passwordFocusNode,
                    isPasswordField: true,
                    // textInputAction: TextInputAction.done,
                  ),
                  CustomButton(
                    text: "Login",
                    onPressed: () {
                      submitForm();
                    },
                    outlineButton: false,
                    isLoading: loginFormLoading,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: CustomButton(
                  text: "Create New Account",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
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
