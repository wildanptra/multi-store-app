import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

class SupplierStatics extends StatelessWidget {
  const SupplierStatics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Supplier Statics'
        ),
        leading: const AppBarBackButton(),
      ),
    );
  }
}