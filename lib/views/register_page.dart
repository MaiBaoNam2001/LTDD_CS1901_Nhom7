import 'package:ecommerce_app/styles.dart';
import 'package:ecommerce_app/widgets/custom_button.dart';
import 'package:ecommerce_app/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  Future<String> createAccount() async {
    if (registerPassword != registerConfirmPassword) {
      return 'The confirmation password provided is incorrect.';
    }
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: registerEmail, password: registerPassword);
      return '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  void submitForm() async {
    setState(() {
      registerFormLoading = true;
    });

    String createAccountFeedback = await createAccount();
    if (createAccountFeedback != '') {
      alertDialogBuilder(createAccountFeedback);

      setState(() {
        registerFormLoading = false;
      });
    }else{
      Navigator.pop(context);
    }
  }

  bool registerFormLoading = false;

  String registerEmail = "";
  String registerPassword = "";
  String registerConfirmPassword = "";

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;

  @override
  void initState() {
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
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
                  "Create A New Account",
                  textAlign: TextAlign.center,
                  style: Styles.boldHeading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText: "Email",
                    onChanged: (value) {
                      registerEmail = value;
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
                      registerPassword = value;
                    },
                    onSubmitted: (value) {
                      confirmPasswordFocusNode.requestFocus();
                    },
                    focusNode: passwordFocusNode,
                    isPasswordField: true,
                    // textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                    hintText: "Confirm Password",
                    onChanged: (value) {
                      registerConfirmPassword = value;
                    },
                    onSubmitted: (value) {},
                    focusNode: confirmPasswordFocusNode,
                    isPasswordField: true,
                    // textInputAction: TextInputAction.done,
                  ),
                  CustomButton(
                    text: "Create Account",
                    onPressed: () {
                      submitForm();
                    },
                    outlineButton: false,
                    isLoading: registerFormLoading,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: CustomButton(
                  text: "Back To Login",
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
