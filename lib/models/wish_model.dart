import  'package:flutter/material.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/product_class.dart';
import 'package:multi_store_app/providers/wish_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class WishlistModel extends StatelessWidget {
  const WishlistModel({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

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
                child: Image.network(product.imagesUrl.first),
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
                            color: Colors.grey.shade700),
                      ),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.price.toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: (){
                                  context.read<Wish>().removeItem(product);
                                },
                                icon: const Icon(Icons.delete_forever),
                              ),
                              const SizedBox(width: 10,),
                              context
                                .watch<Cart>().getItems
                                .firstWhereOrNull(
                                  (element) => element.documentId == product.documentId
                                ) != null 
                              ? const SizedBox() 
                              : IconButton(
                                onPressed:(){
                                  context.read<Cart>().addItem(
                                    product.name,
                                    product.price,
                                    1,
                                    product.qntty,
                                    product.imagesUrl,
                                    product.documentId,
                                    product.supplierId,
                                  );
                                },
                                icon: const Icon(Icons.add_shopping_cart),
                              ),
                            ],
                          ),
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