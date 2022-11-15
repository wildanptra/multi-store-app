import 'package:flutter/cupertino.dart';
import  'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/product_class.dart';
import 'package:multi_store_app/providers/wish_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CartModel extends StatelessWidget {
  const CartModel({
    Key? key,
    required this.product,
    required this.cart,
  }) : super(key: key);

  final Product product;
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 120,
                child: Image.network(
                  product.imagesUrl.first
                ),
              ),
               Flexible(
                 child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.price.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red
                              ),
                            ),
                            Container(
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child:Row(
                                children: [
                                  product.qty == 1 ? IconButton(
                                    onPressed: (){
                                       showCupertinoModalPopup<void>(
                                         context: context,
                                         builder: (BuildContext context) => CupertinoActionSheet(
                                           title: const Text('Remove Item'),
                                           message: const Text('Are you sure to remove this item ?'),
                                           actions: <CupertinoActionSheetAction>[
                                             CupertinoActionSheetAction(
                                               onPressed: () async {
                                                 context
                                                         .read<Wish>()
                                                         .getWishItems
                                                         .firstWhereOrNull((element) =>
                                                             element.documentId ==
                                                             product.documentId) !=
                                                     null
                                                 ? context.read<Cart>().removeItem(
                                                     product)
                                                 : await context.read<Wish>().addWishItem(
                                                       product.name,
                                                       product.price,
                                                       1,
                                                       product.qntty,
                                                       product.imagesUrl,
                                                       product.documentId,
                                                       product.supplierId,
                                                     );
                                                     context.read<Cart>().removeItem(
                                                     product);
                                                     Navigator.pop(context);
                                                 },
                                               child: const Text('Move To Wishlist'),
                                             ),
                                             CupertinoActionSheetAction(
                                               onPressed: () {
                                                 context.read<Cart>().removeItem(product);
                                                 Navigator.pop(context);
                                               },
                                               child: const Text('Delete Item'),
                                             ),
                                             CupertinoActionSheetAction(
                                               isDestructiveAction: true,
                                               onPressed: () {
                                                 Navigator.pop(context);
                                               },
                                               child: const Text('Cancel'),
                                             ),
                                           ],
                                         ),
                                       );
                                       // cart.removeItem(product);
                                    }, 
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      size: 18,
                                    ),
                                  ) : IconButton(
                                    onPressed: (){
                                      cart.reduceByOne(product);
                                    }, 
                                    icon: const Icon(
                                      FontAwesomeIcons.minus,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    product.qty.toString(), 
                                    style: product.qty == product.qntty ? GoogleFonts.acme(
                                      fontSize: 18,
                                      color: Colors.red
                                    ) : GoogleFonts.acme(
                                      fontSize: 18,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: product.qty == product.qntty 
                                    ? 
                                    null 
                                    : (){
                                      cart.increment(product);
                                    }, 
                                    icon: const Icon(
                                      FontAwesomeIcons.plus,
                                      size: 18,
                                    ),
                                  ),
                                ]
                              ) ,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}