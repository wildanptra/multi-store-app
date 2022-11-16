import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedValue = 1;
  late String orderId;
  CollectionReference customers = FirebaseFirestore.instance.collection('customers');

  void showProgress(){
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'please wait ...', progressBgColor: Colors.red);
  }

  @override
  Widget build(BuildContext context) {

    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice + 10.0;

    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Material(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(color: Colors.purple,)
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Material(
            color: Colors.grey.shade200,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.grey.shade200,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.grey.shade200,
                  leading: const AppBarBackButton(),
                  title: const  AppBarTitle(
                    title: 'Payment'
                  ),
                  centerTitle: true,
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 16
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total', 
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    '${totalPaid.toStringAsFixed(2)} USD',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.black,
                                thickness: 1,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Order Total', 
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                  Text(
                                    '${totalPrice.toStringAsFixed(2)} USD',
                                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Shipping Coast', 
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                  Text(
                                    '10.00 USD',
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Expanded(
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white, 
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              RadioListTile(
                                value: 1,
                                groupValue: selectedValue,
                                onChanged: (int? value){
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text('Cash On Delivery'),
                                subtitle: const Text('Pay Cash At Home'),
                              ),
                              RadioListTile(
                                value: 2,
                                groupValue: selectedValue,
                                onChanged: (int? value){
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text('Pay via Visa / Master Card'),
                                subtitle: Row(
                                  children: const [
                                    Icon(Icons.payment, color: Colors.blue),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15
                                      ),
                                      child: Icon(FontAwesomeIcons.ccMastercard, color: Colors.blue),
                                    ),
                                    Icon(FontAwesomeIcons.ccVisa, color: Colors.blue)
                                  ],
                                ),
                              ),
                              RadioListTile(
                                value: 3,
                                groupValue: selectedValue,
                                onChanged: (int? value){
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text('Pay via Paypal'),
                                subtitle: Row(
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.paypal, 
                                      color: Colors.blue
                                    ),
                                    SizedBox(width: 11,),
                                    Icon(
                                      FontAwesomeIcons.ccPaypal, 
                                      color: Colors.blue
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomSheet: Container(
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: YellowButton(
                      label: 'Confirm ${totalPaid.toStringAsFixed(2)} USD', 
                      width: 1, 
                      onPressed: () {
                        if(selectedValue == 1){

                          showModalBottomSheet(
                            context: context, 
                            builder: (context) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 50
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Pay At Home ${totalPaid.toStringAsFixed(2)} \$',
                                      style: const TextStyle(
                                        fontSize: 24
                                      ),
                                    ),
                                    YellowButton(
                                      label: 'Confirm ${totalPaid.toStringAsFixed(2)} \$', 
                                      onPressed: () async{
                                        showProgress();
                                        for(var item in context.read<Cart>().getItems){
                                          CollectionReference orderRef = FirebaseFirestore.instance.collection('orders');
                                          
                                          orderId = const Uuid().v4();

                                          await orderRef.doc(orderId).set({

                                            'cid' : data['cid'],
                                            'customerName' : data['name'],
                                            'email' : data['email'],
                                            'address' : data['address'],
                                            'phone' : data['phone'],
                                            'profileImage' : data['profileImage'],

                                            'sid' : item.supplierId,
                                            'productId' : item.documentId,
                                            'orderId' : orderId,
                                            'orderName' : item.name,
                                            'orderImage' : item.imagesUrl.first,
                                            'qty' : item.qty,
                                            'orderPrice': item.qty * item.price,

                                            'deliveryStatus' : 'preparing',
                                            'deliveryDate' : '',
                                            'orderDate' : DateTime.now(),
                                            'paymentStatus' : 'cash on delivery',
                                            'orderReview' : false,
                                            
                                          }).whenComplete(() async{
                                            await FirebaseFirestore.instance.runTransaction((transaction) async{
                                              DocumentReference documentReference = FirebaseFirestore.instance.collection('products').doc(item.documentId); 
                                              DocumentSnapshot snapshot2 =  await transaction.get(documentReference);
                                              transaction.update(documentReference, {
                                                'instock' : snapshot2['instock'] - item.qty
                                              });
                                            });
                                          });
                                        }
                                        context.read<Cart>().clearCart();
                                        Navigator.popUntil(context, ModalRoute.withName('/customer_home'));
                                      },
                                      width: 0.9
                                    ),
                                  ]
                                ),
                              ),
                            ),
                          );

                        }else if(selectedValue == 2){
                          // ignore: avoid_print
                          print('visa/mastercard');
                        }else if(selectedValue == 3){
                          // ignore: avoid_print
                          print('paypal');
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator(color: Colors.purple));
      },
    );

  }
}