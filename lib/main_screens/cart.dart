import 'package:flutter/material.dart';
import 'package:multi_store_app/models/cart_model.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/widgets/alert_dialog.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final Widget? back;
  const CartScreen({super.key,this.back});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: widget.back,
            centerTitle: true,
            title: const AppBarTitle(title: 'Cart'),
            actions: [
              context.watch<Cart>().getItems.isEmpty ? const SizedBox()  : 
              IconButton(
                onPressed: (){
                  MyAlertDilaog.showMyDialog(
                    context: context,
                    title: 'Clear Cart',
                    content: 'Are you sure to clear cart ?',
                    tabNo: (){
                      Navigator.pop(context);
                    },
                    tabYes: (){
                      context.read<Cart>().clearCart();
                      Navigator.pop(context);
                    }
                  );
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          body: context.watch<Cart>().getItems.isNotEmpty ? const CartItem() : const EmptyCart(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children:[
                    const Text(
                      'Total: \$ ',
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                    Text(
                      context.watch<Cart>().totalPrice.toStringAsFixed(2),
                      style: const  TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red
                      ),
                    ),
                  ],
                ),
                YellowButton(
                  width: 0.45,
                  label: 'CHECK OUT',
                  onPressed: (){},
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your Cart Is Empty !',
              style: TextStyle(
                fontSize: 30
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Material(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(25),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.6,
                onPressed: (){
                  Navigator.canPop(context) 
                  ? Navigator.pop(context) 
                  : Navigator.pushReplacementNamed(context, '/customer_home');
                },
                child: const Text(
                  'continue shopping',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
     builder: (context, cart, child) {
       return ListView.builder(
         itemCount: cart.count,
         itemBuilder: (context, index){

           final product = cart.getItems[index];

           return CartModel(product: product, cart: context.read<Cart>(),);
         }
       );
     },
          );
  }
}
