// ignore_for_file: avoid_print, unused_field

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditStore extends StatefulWidget {
  final dynamic data;
  const EditStore({
    super.key,
    required this.data,
  });

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {

  final GlobalKey<FormState> formKey  = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey  = GlobalKey<ScaffoldMessengerState>();
  
  // packages for image picker
  final ImagePicker _picker = ImagePicker();

  // file image
  XFile? _imageFileLogo;
  XFile? _imageFileCover;

  // file image error
  dynamic _pickImageError;

  late String storeName;
  late String phone;
  late String storeLogo;
  late String coverImage;
  bool processing = false;

  pickStoreLogo() async {
    try {
      final pickedStoreLogo = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFileLogo = pickedStoreLogo;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }
  
  pickCoverImage() async {
    try {
      final pickedCoverImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFileCover = pickedCoverImage;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  Future uploadStoreLogo() async {
    if(_imageFileLogo != null){
      try {
        firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref('supp-images/${widget.data['email']}.jpg');

        await ref.putFile(File(_imageFileLogo!.path));

        storeLogo = await ref.getDownloadURL();

      } catch(e) {
        print(e);
      }
    }else{
      storeLogo = widget.data['storeLogo'];
    }
  }

  Future uploadCoverImage() async {
    if(_imageFileCover != null){
      try {
        firebase_storage.Reference ref2 = firebase_storage
          .FirebaseStorage.instance
          .ref('supp-images/${widget.data['email']}-cover.jpg');

        await ref2.putFile(File(_imageFileCover!.path));

        coverImage = await ref2.getDownloadURL();

      } catch(e) {
        print(e);
      }
    }else{
      coverImage = widget.data['coverImage'];
    }
  }

  editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore
        .instance
        .collection('suppliers')
        .doc(FirebaseAuth.instance.currentUser!.uid);

        transaction.update(documentReference, {
          'storeName' : storeName,
          'phone' : phone,
          'storeLogo' : storeLogo,
          'coverImage' : coverImage,
        });
    }).whenComplete(() => Navigator.pop(context));
  }

  saveChanges() async{
    if(formKey.currentState!.validate()){
      // continue
      formKey.currentState!.save();
      
      setState(() {
        processing = true;
      });

      await uploadStoreLogo().whenComplete(
        () async => await uploadCoverImage().whenComplete(() => editStoreData()));

    }else{
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBarBackButton(),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const AppBarTitle(title: 'Edit Store',),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Column(
                  children:  [
                    const Text(
                      'Store Logo', 
                      style: TextStyle(
                        fontSize: 24, 
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(widget.data['storeLogo']),
                        ),
                        Column(
                          children: [
                            YellowButton(
                              label: 'Change', 
                              onPressed: (){
                                pickStoreLogo();
                              }, 
                              width: 0.25
                            ),
                            const SizedBox(height: 10,),
                            _imageFileLogo == null ? const SizedBox() :  YellowButton(
                              label: 'Reset', 
                              onPressed: (){
                                setState(() {
                                  _imageFileLogo = null;
                                });
                              }, 
                              width: 0.25
                            ),
                          ],
                        ),
                        _imageFileLogo == null ? const SizedBox() : CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(File(_imageFileLogo!.path))
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Divider(color: Colors.yellow, thickness: 2.5,),
                    ),
                  ],
                ),
                Column(
                  children:  [
                    const Text(
                      'Cover Image', 
                      style: TextStyle(
                        fontSize: 24, 
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(widget.data['coverImage']),
                        ),
                        Column(
                          children: [
                            YellowButton(
                              label: 'Change', 
                              onPressed: (){
                                pickCoverImage();
                              }, 
                              width: 0.25
                            ),
                            const SizedBox(height: 10,),
                            _imageFileCover == null ? const SizedBox() :  YellowButton(
                              label: 'Reset', 
                              onPressed: (){
                                setState(() {
                                  _imageFileCover = null;
                                });
                              }, 
                              width: 0.25
                            ),
                          ],
                        ),
                        _imageFileCover == null ? const SizedBox() : CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(File(_imageFileCover!.path))
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Divider(color: Colors.yellow, thickness: 2.5,),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please Enter Store Name';
                      }
          
                      return null;
                    },
                    onSaved: (value){
                      storeName = value!;
                    },
                    initialValue: widget.data['storeName'],
                    decoration: textFormDecoration.copyWith(labelText: 'Store Name', hintText: 'Enter Store Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please Phone Number';
                      }
          
                      return null;
                    },
                    onSaved: (value){
                      phone = value!;
                    },
                    initialValue: widget.data['phone'],
                    decoration: textFormDecoration.copyWith(labelText: 'Phone', hintText: 'Enter Phone Number'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 40
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      YellowButton(
                        label: 'Cancel', 
                        onPressed: (){
                          Navigator.pop(context);
                        }, 
                        width: 0.25,
                      ),
                      processing == true ? YellowButton(
                        label: 'Please Wait ...', 
                        onPressed: (){
                          null;
                        }, 
                        width: 0.5,
                      ) :  YellowButton(
                        label: 'Save Changes', 
                        onPressed: (){
                          saveChanges();
                        }, 
                        width: 0.5,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
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