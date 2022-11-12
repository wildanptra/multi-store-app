import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screens/product_detail.dart';

class ProductModel extends StatelessWidget {
  final dynamic products;
  const ProductModel({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(productList: products,)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15)
            ),
            child: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(minHeight: 100, maxHeight: 250),
                  child: Image(image: NetworkImage(products['productImages'][0])),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        products['productName'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            products['price'].toStringAsFixed(2) + (' \$'),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          products['sid'] == FirebaseAuth.instance.currentUser!.uid  
                          ? IconButton(
                            onPressed: (){}, 
                            icon: const Icon(
                              Icons.edit, 
                              color: Colors.red,
                            ),
                          ) : IconButton(
                            onPressed: (){}, 
                            icon: const Icon(
                              Icons.favorite_border_outlined, 
                              color: Colors.red,
                            ),
                          ) ,
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}