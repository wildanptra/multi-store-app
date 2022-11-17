import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ManageProducts extends StatefulWidget {
  const ManageProducts({super.key});

  @override
  State<ManageProducts> createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
  .collection('products')
  .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Manage Products'
        ),
        leading: const AppBarBackButton(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.data!.docs.isEmpty){
            return Center(
              child:Text(
                'This category \n\n has no items yet !',
                textAlign: TextAlign.center,
                style: GoogleFonts.acme(
                  fontSize: 26, 
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              )
            );
          }else{
            return SingleChildScrollView(
              child: StaggeredGridView.countBuilder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                crossAxisCount: 2, 
                itemBuilder: (context, index){
                  return ProductModel(
                    products: snapshot.data!.docs[index]
                  );
                }, 
                staggeredTileBuilder: (context) => const StaggeredTile.fit(1)),
            );
          }
        },
      ),
    );
  }
}