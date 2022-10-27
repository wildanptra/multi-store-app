import 'package:flutter/material.dart';
import 'package:multi_store_app/categories/men_categ.dart';
import 'package:multi_store_app/widgets/fake_search.dart';

List<ItemsData> items = [
  ItemsData(label: 'men'),
  ItemsData(label: 'woman'),
  ItemsData(label: 'shoes'),
  ItemsData(label: 'bags'),
  ItemsData(label: 'electronics'),
  ItemsData(label: 'accessories'),
  ItemsData(label: 'home & garden'),
  ItemsData(label: 'kids'),
  ItemsData(label: 'beauty'),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final PageController _pageController = PageController();

  @override
  void initState(){
    for (var element in items) {
      element.isSelected = false;
    }
    setState(() {
      items[0].isSelected = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const FakeSearch(),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: sideNavigator(size),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: categView(size),
          ),
        ],
      ),
    );
  }

  Widget sideNavigator(Size size) {
    return SizedBox(
      height: size.height * 0.85,
      width: size.width * 0.2,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.bounceInOut);
            },
            child: Container(
              height: 100,
              color: items[index].isSelected
                  ? Colors.white
                  : Colors.grey.shade300,
              child: Center(
                child: Text(
                  items[index].label
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget categView(Size size) {
    return Container(
      height: size.height * 0.85,
      width: size.width * 0.8,
      color: Colors.white,
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          for (var element in items) {
            element.isSelected = false;
          }
          setState(() {
            items[value].isSelected = true;
          });
        },
        scrollDirection: Axis.vertical,
        children: const [
          MenCategory(),
          Center(
            child: Text('women category'),
          ),
          Center(
            child: Text('shoes category'),
          ),
          Center(
            child: Text('bags category'),
          ),
          Center(
            child: Text('electronics category'),
          ),
          Center(
            child: Text('accessoires category'),
          ),
          Center(
            child: Text('home and garden category'),
          ),
          Center(
            child: Text('kids category'),
          ),
          Center(
            child: Text('beauty category'),
          ),
        ],
      ),
    );
  }
}

class ItemsData {
  String label;
  bool isSelected;
  ItemsData({required this.label, this.isSelected = false});
}
