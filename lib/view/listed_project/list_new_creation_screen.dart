import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListNewCreationScreen extends StatefulWidget {
  const ListNewCreationScreen({super.key});

  @override
  State<ListNewCreationScreen> createState() => _ListNewCreationScreenState();
}

class _ListNewCreationScreenState extends State<ListNewCreationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text("List new creation"),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
