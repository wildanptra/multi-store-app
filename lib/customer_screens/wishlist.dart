import 'package:flutter/material.dart';
import 'package:multi_store_app/models/wish_model.dart';
import 'package:multi_store_app/providers/wish_provider.dart';
import 'package:multi_store_app/widgets/alert_dialog.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: const AppBarBackButton(),
            centerTitle: true,
            title: const AppBarTitle(title: 'Wishlist'),
            actions: [
              context.watch<Wish>().getWishItems.isEmpty ? const SizedBox()  :
              IconButton(
                onPressed: (){
                  MyAlertDilaog.showMyDialog(
                    context: context,
                    title: 'Clear Wishlist',
                    content: 'Are you sure to clear wishlist ?',
                    tabNo: (){
                      Navigator.pop(context);
                    },
                    tabYes: (){
                      context.read<Wish>().clearWishlist();
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
          body: context.watch<Wish>().getWishItems.isNotEmpty
              ? const WishlistItems()
              : const EmptyWishlist(),
        ),
      ),
    );
  }
}

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Your Wishlist Is Empty !',
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}

class WishlistItems extends StatelessWidget {
  const WishlistItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Wish>(
      builder: (context, wish, child) {
        return ListView.builder(
            itemCount: wish.count,
            itemBuilder: (context, index) {
              final product = wish.getWishItems[index];

              return WishlistModel(product: product);
            });
      },
    );
  }
}
