import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

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
        leading: const AppBarBackButton(),
        centerTitle: true,
        title: AppBarTitle(title: subcategName),
      ),
      body: Center(
        child: Text(maincategName)
      ),
    );
  }
}
