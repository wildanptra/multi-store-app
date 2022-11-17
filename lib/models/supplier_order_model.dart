import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class SupplierOrderModel extends StatelessWidget {
  final dynamic order;
  const SupplierOrderModel({super.key, required this.order});

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
                      order['orderImage'],
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
                        order['orderName'],
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
                                (order['orderPrice'].toStringAsFixed(2))),
                            Text(('x ') + (order['qty'].toString()))
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
              Text(order['deliveryStatus']),
            ],
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ('Name : ') + (order['customerName']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Phone Number : ') + (order['phone'].toString()),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Email Address : ') + (order['email']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      ('Address : ') + (order['address']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Payment Status : ',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          order['paymentStatus'],
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
                          order['deliveryStatus'],
                          style: const TextStyle(
                              fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Order Date : ',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd')
                              .format(order['orderDate'].toDate())
                              .toString(),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    order['deliveryStatus'] == 'delivered'
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child:
                                Text('This order has been already delivered'),
                          )
                        : Row(
                            children: [
                              const Text(
                                'Change Delivery Status To: ',
                                style: TextStyle(fontSize: 15),
                              ),
                              order['deliveryStatus'] == 'preparing'
                                  ? TextButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(
                                          context,
                                          minTime: DateTime.now(),
                                          maxTime: DateTime.now().add(const Duration(days: 365)),
                                          onConfirm: (date) async{
                                            await FirebaseFirestore.instance.collection('orders').doc(order['orderId']).update({
                                              'deliveryStatus' : 'shipping',
                                              'deliveryDate' : date,
                                            });
                                          }
                                        );
                                      },
                                      child: const Text('shipping ?'))
                                  : TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance.collection('orders').doc(order['orderId']).update({
                                              'deliveryStatus' : 'delivered',
                                            });
                                      },
                                      child: const Text('delivered ?')),
                            ],
                          ),
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
