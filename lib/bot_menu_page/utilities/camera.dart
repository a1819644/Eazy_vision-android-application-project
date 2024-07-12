import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Camera extends StatefulWidget {

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<Camera> {

  // some initialization code
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  get postID => null;

  // image Picker
  Future imagePickerMethod() async {

    // picking the file
    final pick = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        // showing a snackbar with error
        showSnackBar("No file selected", const Duration(milliseconds: 400));
      }
    });
  }

  // uploading the image, then getting the download url and then
  // adding that download url to our cloudfirestore

  Future uploadImage() async {
    final postId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? _userCredential = await _auth.currentUser; // getting current use
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${_userCredential?.uid}/images")
        .child("post_$postID");
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();
    List<String> photoLinks = [];
    photoLinks.add(downloadURL!);
    // uploading to cloudfirestore

    await firebaseFirestore
        .collection("users")
        .doc(_userCredential?.uid)
        .update({
          'photoLink':FieldValue.arrayUnion(photoLinks),
         })
        .whenComplete(() => showSnackBar(
        "Image Uploaded Successfully :)", const Duration(seconds: 2)));
  }

  //snackbar for showing errors
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Image Upload"),),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            // for rounded rectange clip
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SizedBox(
                height: 550,
                width: double.infinity,
                child: Column(
                  children: [
                    const Text("Upload Image"),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        flex: 4,
                        child: Container(
                          width: 350,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.red)),
                          child: Center(
                            child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: _image == null
                                        ? const Center(
                                        child: Text("No image selected"))
                                        : Image.file(_image!),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        imagePickerMethod();
                                      },
                                      child: const Text("Select image")),
                                  ElevatedButton(
                                      onPressed: () {
                                        // upload only when the image has some values
                                        if (_image != null) {
                                          uploadImage();
                                        } else {
                                          showSnackBar(
                                              "Select Image First",
                                              const Duration(
                                                  milliseconds: 400));
                                        }
                                        uploadImage().whenComplete(() =>
                                            showSnackBar(
                                                "Image Uploaded Successfully :)",
                                                const Duration(seconds: 2)));
                                      },
                                      child: const Text("Upload image")),
                                ]),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
