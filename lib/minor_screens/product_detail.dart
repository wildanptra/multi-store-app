import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/minor_screens/full_screen_view.dart';
import 'package:multi_store_app/minor_screens/visit_store.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic productList;
  const ProductDetailScreen({super.key, required this.productList});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late List<dynamic> imagesList = widget.productList['productImages'];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('mainCategory', isEqualTo: widget.productList['mainCategory'])
        .where('subCategory', isEqualTo: widget.productList['subCategory'])
        .snapshots();

    return Material(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullScreenView(
                                  imagesList: imagesList,
                                )));
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Swiper(
                            pagination: const SwiperPagination(
                                builder: SwiperPagination.fraction),
                            itemBuilder: (context, index) {
                              return Image(
                                  image: NetworkImage(imagesList[index]));
                            },
                            itemCount: imagesList.length),
                      ),
                      Positioned(
                        left: 15,
                        top: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.yellow,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        top: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.yellow,
                          child: IconButton(
                            icon: const Icon(
                              Icons.share,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productList['productName'],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'USD ',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                widget.productList['price'].toStringAsFixed(2),
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${widget.productList['instock'].toString()} Pieces available in stock',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.blueGrey),
                      ),
                      const ProductDetailLabel(
                        label: 'Item Description',
                      ),
                      Text(
                        widget.productList['productDescription'],
                        textScaleFactor: 1.1,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey.shade800),
                      ),
                      const ProductDetailLabel(
                        label: 'Similar Items',
                      ),
                      SizedBox(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _productsStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                  child: Text(
                                'This category \n\n has no items yet !',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.acme(
                                  fontSize: 26,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ));
                            } else {
                              return SingleChildScrollView(
                                child: StaggeredGridView.countBuilder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    crossAxisCount: 2,
                                    itemBuilder: (context, index) {
                                      return ProductModel(
                                          products: snapshot.data!.docs[index]);
                                    },
                                    staggeredTileBuilder: (context) =>
                                        const StaggeredTile.fit(1)),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VisitStore(
                                    supplierId: widget.productList['sid'])));
                      },
                      icon: const Icon(Icons.store),
                    ),
                    SizedBox(
                      width: 90,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_cart),
                      ),
                    ),
                  ],
                ),
                YellowButton(
                    label: 'Add To Cart', onPressed: () {}, width: 0.55)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailLabel extends StatelessWidget {
  final String label;
  const ProductDetailLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
          Text(
            '  $label  ',
            style: TextStyle(
                color: Colors.yellow.shade900,
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
