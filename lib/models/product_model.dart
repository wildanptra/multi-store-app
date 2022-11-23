import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screens/edit_product.dart';
import 'package:multi_store_app/minor_screens/product_detail.dart';
import 'package:multi_store_app/providers/wish_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductModel extends StatefulWidget {
  final dynamic products;
  const ProductModel({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.products['discount'];
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(productList: widget.products,)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(minHeight: 100, maxHeight: 200),
                      child: Image(image: NetworkImage(widget.products['productImages'][0]), fit: BoxFit.cover,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            widget.products['productName'],
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
                              Row(
                                children: [
                                  const Text(
                                    '\$ ', 
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    widget.products['price'].toStringAsFixed(2),
                                    style: onSale != 0 ?  const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.lineThrough
                                    ) : const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6
                                  ),
                                  onSale != 0 ? Text(
                                    ((1 - (onSale / 100)) * widget.products['price']).toStringAsFixed(2),
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ) : const Text(''),
                                ],
                              ),
                              widget.products['sid'] == FirebaseAuth.instance.currentUser!.uid  
                              ? IconButton(
                                onPressed: (){
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(
                                      builder: (context) => EditProduct(items: widget.products,) 
                                    ));
                                }, 
                                icon: const Icon(
                                  Icons.edit, 
                                  color: Colors.red,
                                ),
                              ) : IconButton(
                                  onPressed: () {
                                    var existingItemWishList = context
                                                .read<Wish>()
                                                .getWishItems
                                                .firstWhereOrNull((product) =>
                                                    product.documentId ==
                                                    widget.products[
                                                        'productId']);
                                    existingItemWishList != null 
                                    ? context.read<Wish>().removeThis(widget.products['productId'])
                                    : context.read<Wish>().addWishItem(
                                        widget.products['productName'],
                                        onSale != 0 ? ((1 - (widget.products['discount'] / 100)) * widget.products['price']) : widget.products['price'],
                                        1,
                                        widget.products['instock'],
                                        widget.products['productImages'],
                                        widget.products['productId'],
                                        widget.products['sid'],
                                      ); 
                                  },
                                  icon: context.watch<Wish>().getWishItems
                                    .firstWhereOrNull(
                                    (product) => product.documentId == widget.products['productId']
                                    ) != null ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 30,
                                  ): const Icon(
                                    Icons.favorite_border_outlined,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onSale != 0 ?  Positioned(
                top: 30,
                left: 0,
                child: Container(
                  height: 25,
                  width: 80,
                  decoration: const BoxDecoration(
                    color: Colors.yellow, 
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15), 
                      bottomRight: Radius.circular(15)
                    ),
                  ),
                  child: Center(
                    child: Text('Save ${onSale.toString()} %'),
                  ),
                ),
              ) : Container(color: Colors.transparent,),
            ],
          ),
        ),
      ),
    );
  }
}