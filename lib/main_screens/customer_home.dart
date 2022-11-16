import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screens/cart.dart';
import 'package:multi_store_app/main_screens/category.dart';
import 'package:multi_store_app/main_screens/home.dart';
import 'package:multi_store_app/main_screens/profile.dart';
import 'package:multi_store_app/main_screens/stores.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const HomeScreen(),
    const CategoryScreen(),
    const StoresScreen(),
    const CartScreen(),
    ProfileScreen(documentId: FirebaseAuth.instance.currentUser!.uid,),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600
        ),
        currentIndex: _selectedIndex,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Category'
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Store'
          ),
          BottomNavigationBarItem(
            icon: Badge(
              showBadge: context.read<Cart>().getItems.isEmpty
                  ? false
                  : true,
              padding: const EdgeInsets.all(2),
              badgeColor: Colors.yellow,
              badgeContent: Text(
                context
                    .watch<Cart>()
                    .getItems
                    .length
                    .toString(),
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
              child: const Icon(Icons.shopping_cart)
            ),
            label: 'Cart'
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile'
          ),
        ],
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}