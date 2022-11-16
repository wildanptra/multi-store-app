import 'package:flutter/material.dart';

class CustomerOrderModel extends StatelessWidget {
  final dynamic order;
  const CustomerOrderModel({super.key, required this.order });

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
                color: order['deliveryStatus'] == 'delivered'
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
                    order['deliveryStatus'] == 'shipping'
                        ? Text(
                            ('Estimated Delivery Date : ') +
                                (order['deliveryDate']),
                            style: const TextStyle(fontSize: 15),
                          )
                        : const Text(''),
                    order['deliveryStatus'] == 'delivered' &&
                            order['orderReview'] == false
                        ? TextButton(
                            onPressed: () {},
                            child: const Text('Write Review'),
                          )
                        : const Text(''),
                    order['deliveryStatus'] == 'delivered' &&
                            order['orderReview'] == true
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