// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';

class CustomerOrderModel extends StatefulWidget {
  final dynamic order;
  const CustomerOrderModel({super.key, required this.order });

  @override
  State<CustomerOrderModel> createState() => _CustomerOrderModelState();
}

class _CustomerOrderModelState extends State<CustomerOrderModel> {

  late double rate;
  late String comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.yellow,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(maxHeight: 80, maxWidth: 80),
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(
                      widget.order['orderImage'],
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.order['orderName'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(('\$') +
                                (widget.order['orderPrice'].toStringAsFixed(2))),
                            Text(('x ') + (widget.order['qty'].toString()))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('See More..'),
              Text(widget.order['deliveryStatus']),
            ],
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.order['deliveryStatus'] == 'delivered'
                    ? Colors.brown.withOpacity(0.2)
                    : Colors.yellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ('Name : ') + (widget.order['customerName']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Phone Number : ') + (widget.order['phone'].toString()),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Email Address : ') + (widget.order['email']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Address : ') + (widget.order['address']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Payment Status : ',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          widget.order['paymentStatus'],
                          style: const TextStyle(
                              fontSize: 15, color: Colors.purple),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Delivery Status : ',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          widget.order['deliveryStatus'],
                          style: const TextStyle(
                              fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    widget.order['deliveryStatus'] == 'shipping'
                        ? Text(
                            ('Estimated Delivery Date : ') +
                                (DateFormat('yyyy-MM-dd')
                              .format(widget.order['deliveryDate'].toDate())
                              .toString()),
                            style: const TextStyle(fontSize: 15),
                          )
                        : const Text(''),
                    widget.order['deliveryStatus'] == 'delivered' &&
                            widget.order['orderReview'] == false
                        ? TextButton(
                            onPressed: () {
                              showDialog(
                                context: context, 
                                builder: (context) => Material(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 150
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        RatingBar.builder(
                                          initialRating: 1,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 4.0
                                          ),
                                          itemBuilder: (context,_){
                                            return const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            );
                                          }, 
                                          onRatingUpdate: (value){
                                            rate = value;
                                          }
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Enter your review',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.amber,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(15) 
                                            ),
                                          ),
                                          onChanged: (value){
                                            comment = value;
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            YellowButton(
                                              label: 'Cancel', 
                                              onPressed: (){
                                                Navigator.pop(context);
                                              }, 
                                              width: 0.3
                                            ),
                                            const SizedBox(width: 20,),
                                            YellowButton(
                                              label: 'Ok', 
                                              onPressed: () async {
                                                CollectionReference collectionReference =  
                                                FirebaseFirestore.instance
                                                .collection('products')
                                                .doc(widget.order['productId'])
                                                .collection('reviews');

                                                await collectionReference.doc(
                                                  FirebaseAuth.instance.currentUser!.uid
                                                ).set({
                                                  'name' : widget.order['customerName'],
                                                  'email' : widget.order['email'],
                                                  'rate' : rate,
                                                  'comment' : comment,
                                                  'profileImage' : widget.order['profileImage'],
                                                }).whenComplete(() async {
                                                  await FirebaseFirestore.instance.runTransaction((transaction) async{
                                                    DocumentReference documentReference = FirebaseFirestore.instance
                                                    .collection('orders')
                                                    .doc(widget.order['orderId']);

                                                    transaction.update(documentReference, {
                                                      'orderReview' : true,
                                                    });
                                                  });
                                                });

                                                await Future.delayed(const Duration(microseconds: 100)).whenComplete(() => Navigator.pop(context));

                                              }, 
                                              width: 0.3
                                            ), 
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Text('Write Review'),
                          )
                        : const Text(''),
                    widget.order['deliveryStatus'] == 'delivered' &&
                            widget.order['orderReview'] == true
                        ? Row(
                            children: const [
                              Icon(
                                Icons.check,
                                color: Colors.blue,
                              ),
                              Text(
                                'Review Added',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blue),
                              )
                            ],
                          )
                        : const Text(''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}