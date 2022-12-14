import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/customer_screens/address_book.dart';
import 'package:multi_store_app/customer_screens/customer_orders.dart';
import 'package:multi_store_app/customer_screens/wishlist.dart';
import 'package:multi_store_app/main_screens/cart.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

class ProfileScreen extends StatefulWidget {
  final String documentId;
  const ProfileScreen({super.key, required this.documentId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  CollectionReference customers = FirebaseFirestore.instance.collection('customers');
  CollectionReference anonymous = FirebaseFirestore.instance.collection('anonymous');

  @override
  Widget build(BuildContext context) {
    return 
    
    FutureBuilder<DocumentSnapshot>(
      future: FirebaseAuth.instance.currentUser!.isAnonymous 
      ? anonymous.doc(widget.documentId).get() 
      : customers.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Stack(
              children: [
                Container(
                  height: 215,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.yellow, Colors.brown]
                    ),
                  ),
                ),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      expandedHeight: 140,
                      flexibleSpace: LayoutBuilder(
                        builder: (context, constraints) {
                          return FlexibleSpaceBar(
                            centerTitle: true,
                            title: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: constraints.biggest.height <= 120 ? 1 : 0,
                              child: const Text(
                                'Account',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            background: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.yellow, Colors.brown]
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 25,
                                  left: 30
                                ),
                                child: Row(
                                  children: [
                                    data['profileImage'] == '' 
                                    ?  const CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage('images/inapp/guest.jpg'),
                                    ) 
                                    : CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(data['profileImage']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25),
                                      child: Text(
                                        data['name'] == '' ? 'guest'.toUpperCase() : data['name'].toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30)
                                    )
                                  ),
                                  child: TextButton(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      child: const Center(
                                        child: Text(
                                          'Cart',
                                          style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 20
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const CartScreen(back: AppBarBackButton(),))
                                      );
                                    }, 
                                  ),
                                ),
                                Container(
                                  color: Colors.yellow,
                                  child: TextButton(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      child: const Center(
                                        child: Text(
                                          'Orders',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 20
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const CustomerOrders())
                                      );
                                    }, 
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30)
                                    )
                                  ),
                                  child: TextButton(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      child: const Center(
                                        child: Text(
                                          'Wishlist',
                                          style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 20
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const WishlistScreen())
                                      );
                                    }, 
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 150,
                                  child: Image(image: AssetImage('images/inapp/logo.jpg')),
                                ),
                                const ProfileHeaderLabel(headerLabel: 'Account Info',),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 260,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16)
                                    ),
                                    child: Column(
                                      children: [
                                        RepeatedListTile(
                                          icon: Icons.email,
                                          title:'Email Address',
                                          subTitle: data['email'] == '' 
                                          ? 'email not filled in' 
                                          : data['email'],
                                        ),
                                        const YellowDivider(),
                                        RepeatedListTile(
                                          icon: Icons.phone, 
                                          title:'Phone No.',
                                          subTitle: data['phone'] == '' 
                                          ? "phone number not filled in " 
                                          : data['phone'], 
                                        ),
                                        const YellowDivider(),
                                        RepeatedListTile(
                                          onPressed: FirebaseAuth.instance.currentUser!.isAnonymous ? null : (){
                                            Navigator.push(
                                              context, 
                                              MaterialPageRoute(
                                                builder: (context) => const AddressBook()
                                              )
                                            );
                                          },
                                          icon: Icons.location_pin, 
                                          title:'Address',
                                          subTitle: userAddress(data),
                                          // data['address'] == '' 
                                          // ? "address not filled in" 
                                          // : data['address'], 
                                        ),
                                      ]
                                    ),
                                  ),
                                ),
                                const ProfileHeaderLabel(headerLabel: 'Account Settings'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 210,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16)
                                    ),
                                    child: Column(
                                      children: [
                                        RepeatedListTile(
                                          title: 'Edit Profile',
                                          icon: Icons.edit,
                                          onPressed: (){},
                                        ),
                                        const YellowDivider(),
                                        RepeatedListTile(
                                          title: 'Change Password',
                                          icon: Icons.lock,
                                          onPressed: (){},
                                        ),
                                        const YellowDivider(),
                                        RepeatedListTile(
                                          title: 'Log Out',
                                          icon: Icons.logout,
                                          onPressed: () async {
                                            await showCupertinoModalPopup <void>(
                                              context: context,
                                              builder: (BuildContext context) => CupertinoAlertDialog(
                                                title: const Text('Log Out'),
                                                content: const Text('Are you sure to log out?'),
                                                actions: <CupertinoDialogAction>[
                                                  CupertinoDialogAction(
                                                    isDefaultAction: true,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('No'),
                                                  ),
                                                  CupertinoDialogAction(
                                                    isDestructiveAction: true,
                                                    onPressed: () async {
                                                      await FirebaseAuth.instance.signOut();
                                                      await Future.delayed(const Duration(microseconds: 100)).whenComplete(() {
                                                        Navigator.pushReplacementNamed(context, '/welcome_screen');
                                                      });
                                                    },
                                                    child: const Text('Yes'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ]
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator(color: Colors.purple));
      },
    );
  }

  String userAddress(dynamic data){
    if(FirebaseAuth.instance.currentUser!.isAnonymous == true){
      return 'address not filled in because you\'re guest';
    }else if(FirebaseAuth.instance.currentUser!.isAnonymous == false && data['address'] == ''){
      return 'Set Your Address';
    }
    return data['address'];
  }

}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 40
      ),
      child: Divider(
        color: Colors.yellow,
        thickness: 1,
      ),
    );
  }
}

class RepeatedListTile extends StatelessWidget {
  final String title, subTitle;
  final IconData icon;
  final Function()? onPressed;
  const RepeatedListTile({
    Key? key, required this.icon, this.onPressed, this.subTitle = '', required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(subTitle == ''){
      return InkWell(
        onTap: onPressed,
        child:  ListTile(
          title: Text(title),
          leading: Icon(icon),
        ),
      );
    }else{
      return InkWell(
        onTap: onPressed,
        child:  ListTile(
          title: Text(title),
          subtitle: Text(subTitle),
          leading: Icon(icon),
        ),
      );
    }

  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const ProfileHeaderLabel({
    Key? key,
    required this.headerLabel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            '  $headerLabel  ',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 24,
              fontWeight: FontWeight.w600
            ),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
