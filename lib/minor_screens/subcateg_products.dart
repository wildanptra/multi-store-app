import 'package:flutter/material.dart';

class SubCategoryProducts extends StatelessWidget {
  final String maincategName;
  final String subcategName;
  const SubCategoryProducts({
    super.key,
    required this.maincategName,
    required this.subcategName
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          subcategName,
          style: const TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body: Center(
        child: Text(maincategName)
      ),
    );
  }
}