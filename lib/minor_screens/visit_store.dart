import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/minor_screens/edit_store.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VisitStore extends StatefulWidget {
  final String supplierId;
  const VisitStore({
    super.key,
    required this.supplierId
  });

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {

  bool following = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference suppliers = FirebaseFirestore.instance.collection('suppliers');
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
    .collection('products')
    .where('sid', isEqualTo: widget.supplierId)
    .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.supplierId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.blueGrey.shade100,
            appBar: AppBar(
              toolbarHeight: 100,
              flexibleSpace: data['coverImage'] != null ? Image.network(data['coverImage'], fit: BoxFit.cover,) :  Image.asset(
                'images/inapp/coverimage.jpg',
                fit: BoxFit.cover,
              ),
              leading: const YellowBackButton(),
              title: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Colors.yellow
                      ),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.network(
                        data['storeLogo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                                child: Text(
                                  data['storeName'].toString().toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.yellow
                                  ),
                                ),
                              ),
                            ],
                          ),
                          data['sid'] == FirebaseAuth.instance.currentUser!.uid  ?  Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              border: Border.all(width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(25)
                            ),
                            child: MaterialButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditStore(data: data) ));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: const [
                                  Text('Edit'),
                                  Icon(Icons.edit, color: Colors.black,)
                                ]
                              ),
                            )
                          ) : Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              border: Border.all(width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(25)
                            ),
                            child: MaterialButton(
                              onPressed: (){
                                setState(() {
                                  following = !following;
                                });
                              },
                              child: following ? const Text('FOLLOWING') : const Text('FOLLOW'), 
                            )
                          ),
                        ],
                      ),
                    ),
                  )
                ]
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _productsStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if(snapshot.data!.docs.isEmpty){
                    return Center(
                      child:Text(
                        'This Store \n\n has no items yet !',
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
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              child: const Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.white,
                size: 40,
              ),
              onPressed: (){},
            ),
          );
        }

        return const Material(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}