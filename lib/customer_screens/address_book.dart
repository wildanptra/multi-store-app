import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/customer_screens/add_address.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({super.key});

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {

  final Stream<QuerySnapshot> addressStream =  FirebaseFirestore.instance
  .collection('customers')
  .doc(FirebaseAuth.instance.currentUser!.uid)
  .collection('address')
  .snapshots();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey= GlobalKey<ScaffoldMessengerState>();

  Future _handleRefresh() async {
    MyMessageHandler.showSnackBar(_scaffoldKey, 'This page has been loaded');
    return null;
  }

  Future defaultAddressFalse(dynamic item) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore
        .instance
        .collection('customers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('address')
        .doc(item.id);
                          
        transaction.update(documentReference, {
          'default' : false
        });
    });
  }

  Future defaultAddressTrue(dynamic customer) async{
     await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore
        .instance
        .collection('customers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('address')
        .doc(customer['addressId']);
                        
        transaction.update(documentReference, {
          'default' : true,
        });
    });
  }

  Future updateProfile(dynamic customer) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore
        .instance
        .collection('customers')
        .doc(FirebaseAuth.instance.currentUser!.uid);
                          
        transaction.update(documentReference, {
          'address' : customer['country'] + (' - ') + customer['state'] + (' - ') + customer['city'],
          'phone' : customer['phone'],
        });
    });
  }

  void showProgress(){
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'please wait ...', progressBgColor: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: const AppBarTitle(title: 'Address Book'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const AppBarBackButton(),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: addressStream,
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
                          'You have set \n\n an address yet !',
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
                      return RefreshIndicator(
                        onRefresh: _handleRefresh,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index){
                            var customer = snapshot.data!.docs[index]; 
                            return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) async {
                                await FirebaseFirestore.instance.runTransaction((transaction) async {
                                  DocumentReference docReference = FirebaseFirestore
                                    .instance
                                    .collection('customers')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('address')
                                    .doc(customer['addressId']);

                                    transaction.delete(docReference);
                                });
                              },
                              child: GestureDetector(
                                onTap: () async {
                                  showProgress();
                                  for(var item in snapshot.data!.docs){
                                    await defaultAddressFalse(item);
                                  }
                                                      
                                  await defaultAddressTrue(customer).whenComplete(() async => await updateProfile(customer));
                                  Future.delayed(const Duration(microseconds: 100)).whenComplete(() => Navigator.pop(context));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: customer['default'] == true ? Colors.white : Colors.yellow,
                                    child: ListTile(
                                      trailing: customer['default'] == true ? const Icon(Icons.home, color: Colors.brown,) : const SizedBox(),
                                      title: SizedBox(
                                        height: 50,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${customer['firstName']} ${customer['lastName']}'),
                                            Text(customer['phone']),
                                          ]
                                        ),
                                      ),
                                      subtitle: SizedBox(
                                        height: 70,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('city/state : ${customer['city']} - ${customer['state']}'),
                                            Text('country : ${customer['country']}'),
                                          ]
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: YellowButton(
                  label: 'Add New Address', 
                  onPressed: (){
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => const AddAddress()
                      )
                    );
                  }, 
                  width: 0.8
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}