// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int qty;
  late String productName, productDescription, productId;
  int? discount = 0;

  String mainCategValue = 'select category';
  String subCategValue = 'subcategory';
  List<String> subCategList = [];
  bool processing = false;

  // packages for image picker
  final ImagePicker _picker = ImagePicker();

  // file image
  List<XFile>? imagesFileList = [];

  // list image url
  List<String> imagesUrlList = []; 

  // file image error
  dynamic _pickImageError;

  // Collection firebase
  CollectionReference suppliers =
      FirebaseFirestore.instance.collection('suppliers');

  void pickProductImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        imagesFileList = pickedImages;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  void selectedMainCateg(String? value) {
    if (value == 'select category') {
      subCategList = [];
    } else if (value == 'men') {
      subCategList = men;
    } else if (value == 'women') {
      subCategList = women;
    } else if (value == 'electronics') {
      subCategList = electronics;
    } else if (value == 'accessories') {
      subCategList = accessories;
    } else if (value == 'shoes') {
      subCategList = shoes;
    } else if (value == 'home & garden') {
      subCategList = homeandgarden;
    } else if (value == 'beauty') {
      subCategList = beauty;
    } else if (value == 'kids') {
      subCategList = kids;
    } else if (value == 'bags') {
      subCategList = bags;
    }

    print(value);
    setState(() {
      mainCategValue = value!;
      subCategValue = 'subcategory';
    });
  }

  Future<void> uploadImages() async {
    if (mainCategValue != 'select category' && subCategValue != 'subcategory') {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (imagesFileList!.isNotEmpty) {

          setState(() {
            processing = true;
          });

          try {
            for (var image in imagesFileList!) {
              firebase_storage.Reference ref = firebase_storage
                .FirebaseStorage.instance
                .ref('products/${path.basename(image.path)}');

              await ref.putFile(File(image.path)).whenComplete(() async{
                await ref.getDownloadURL().then((value) {
                  imagesUrlList.add(value);
                });
              });
            }
          } catch (e) {
            print(e);
          }

        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'please pick images first');
        }
      } else {
        MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please select categories');
    }
  }

  void uploadData() async {
    if(imagesUrlList.isNotEmpty){
      CollectionReference productRef = FirebaseFirestore.instance.collection('products');

      productId = const Uuid().v4();

      await productRef.doc(productId).set({
        
        'productId' : productId,
        'mainCategory': mainCategValue,
        'subCategory' : subCategValue,
        'price' : price,
        'instock' : qty,
        'productName' : productName,
        'productDescription' : productDescription,
        'sid' : FirebaseAuth.instance.currentUser!.uid,
        'productImages' : imagesUrlList,
        'discount' : discount,

      }).whenComplete(() {
        setState(() {
            processing = false;
            imagesFileList = [];
            mainCategValue = 'select category';
            subCategList = [];
            imagesUrlList = [];
          });

          _formKey.currentState!.reset();
      });
    }else{
      print('no images');
    }
  }

  void uploadProduct () async {
    await uploadImages().whenComplete(() => uploadData());
  }

  Widget previewImages() {
    if (imagesFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: imagesFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(File(imagesFileList![index].path));
          });
    } else {
      return const Center(
        child: Text(
          'you have not pick \n \n pick images yet !',
          style: TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        color: Colors.blueGrey.shade100,
                        height: size.width * 0.5,
                        width: size.width * 0.5,
                        child: imagesFileList != null
                            ? previewImages()
                            : const Center(
                                child: Text(
                                  'you have not pick \n \n pick images yet !',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                      SizedBox(
                        height: size.width * 0.5,
                        width: size.width * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  '* select main category',
                                  style: TextStyle(color: Colors.red),
                                ),
                                DropdownButton(
                                    iconSize: 40,
                                    iconEnabledColor: Colors.red,
                                    dropdownColor: Colors.yellow.shade400,
                                    value: mainCategValue,
                                    items: maincateg
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem(
                                        child: Text(value),
                                        value: value,
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      selectedMainCateg(value);
                                      print(value);
                                      setState(() {
                                        mainCategValue = value!;
                                        subCategValue = 'subcategory';
                                      });
                                    }),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  '* select subcategory',
                                  style: TextStyle(color: Colors.red),
                                ),
                                DropdownButton(
                                    iconSize: 40,
                                    iconEnabledColor: Colors.red,
                                    iconDisabledColor: Colors.black,
                                    dropdownColor: Colors.yellow.shade400,
                                    menuMaxHeight: 500,
                                    disabledHint: const Text('select category'),
                                    value: subCategValue,
                                    items: subCategList
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem(
                                        child: Text(value),
                                        value: value,
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      print(value);
                                      setState(() {
                                        subCategValue = value!;
                                      });
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(
                      color: Colors.yellow,
                      thickness: 1.5,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter price';
                              } else if (value.isValidPrice() != true) {
                                return 'invalid price';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              price = double.parse(value!);
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: textFormDecoration.copyWith(
                              labelText: 'Price',
                              hintText: 'Price..  \$',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: TextFormField(
                            maxLength: 2,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null;
                              }else if (value.isValidDiscount() != true) {
                                return 'invalid discount';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              value!.isEmpty ? null : discount = int.parse(value);
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: textFormDecoration.copyWith(
                              labelText: 'Discount',
                              hintText: 'Discount..  %',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter quantity';
                          } else if (value.isValidQuantity() != true) {
                            return 'not valid quantity';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          qty = int.parse(value!);
                        },
                        keyboardType: TextInputType.number,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Quantity',
                          hintText: 'Add Quantity',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        maxLength: 100,
                        maxLines: 3,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter product name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          productName = value!;
                        },
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Product Name',
                          hintText: 'Enter product name',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        maxLength: 800,
                        maxLines: 3,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter product description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          productDescription = value!;
                        },
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Product Description',
                          hintText: 'Enter product description',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                onPressed: imagesFileList!.isEmpty
                    ? () {
                        pickProductImages();
                      }
                    : () {
                        setState(() {
                          imagesFileList = [];
                        });
                      },
                backgroundColor: Colors.yellow,
                child: Icon(
                    imagesFileList!.isEmpty
                        ? Icons.photo_library
                        : Icons.delete_forever,
                    color: Colors.black),
              ),
            ),
            FloatingActionButton(
              onPressed: processing ? null : () {
                uploadProduct();
              },
              backgroundColor: Colors.yellow,
              child: processing == true ? const CircularProgressIndicator(color: Colors.black,) : const Icon(Icons.upload, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: '',
  hintText: '',
  labelStyle: const TextStyle(color: Colors.purple),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.yellow,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(10)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.blueAccent,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10)),
);

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}

extension DiscountValidator on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9]*)$')
        .hasMatch(this);
  }
}
