import 'package:flutter/material.dart';


class ShareCodeScreen extends StatelessWidget {
  const ShareCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Code')),
      body: const Center(child: Text('Share Code Screen')),
    );
  }
}
