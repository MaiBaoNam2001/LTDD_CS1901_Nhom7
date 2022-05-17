import 'package:flutter/material.dart';
import '../widgets/custom_action_bar.dart';

class SavedTab extends StatelessWidget {
  const SavedTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: const [
          Center(
            child: Text("Saved Tab"),
          ),
          CustomActionBar(
            title: 'Saved',
            hasBackArrow: false,
            hasTitle: true,
            hasBackground: false,
          ),
        ],
      ),
    );
  }
}
