import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/helper/images.dart';
import 'package:amanuel_glass/view/base/custom_button.dart';
import 'package:amanuel_glass/view/components/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/auth_controller.dart';

class EditCard extends GetView<AuthController> {
  final snap;
  const EditCard({Key? key, this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    TextEditingController usernameController =
        TextEditingController(text: snap['name'] ?? '');

    TextEditingController phonenoController =
        TextEditingController(text: snap['phone_number'] ?? '');

    // final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Obx(() {
                return controller.filepath.value != ''
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(
                          File(controller.filepath.value),
                        ),
                      )
                    : snap['profile_url'] != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundColor: MyColors.primary,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: InkResponse(
                                onTap: () async {
                                  //!!1!!
                                  // await pickImage();
                                },
                                child: Stack(
                                  children: [
                                    snap['profile_url'] == ''
                                        ? Image.asset(
                                            Images.placeholder,
                                            fit: BoxFit.cover,
                                            height: 120,
                                            width: 120,
                                          )
                                        : Image.network(
                                            snap['profile_url'],
                                            fit: BoxFit.cover,
                                          ),
                                    const Positioned(
                                      top: 0,
                                      right: 0,
                                      left: 0,
                                      bottom: 0,
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 45,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundColor: MyColors.primary,
                            child: IconButton(
                              onPressed: () async {
                                // !!
                                // await pickImage();
                              },
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                          );
              }),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide()),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: MyColors.primary,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: phonenoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide()),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: MyColors.primary,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: CustomButton(
              fem: 1.1 * fem,
              ffem: ffem,
              title: 'Save',
              onPressed: () async {
                try {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(
                            child: CircularProgressIndicator(
                                color: MyColors.primary),
                          ));
                  String newName = usernameController.text;
                  String newPhone = phonenoController.text;
                  //!Uploading image need firebase that's why it's commented

                  // String imgurl = await uploadImageToStorage(
                  //     'user', controller.file ?? XFile(''));

                  // Get.find<AuthController>()
                  //     .updateUser(newName, newPhone, imgurl);
                } catch (e) {
                  if (kDebugMode) {
                    print('Error updating user: $e');
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  // Future<String> uploadImageToStorage(
  //   String childName,
  //   XFile file,
  // ) async {
  //   final FirebaseStorage _storage = FirebaseStorage.instance;
  //   Reference ref = _storage
  //       .ref()
  //       .child(childName)
  //       .child(Get.find<AuthController>().userPhone ?? '');

  //   if (file.path.isNotEmpty) {
  //     final myfile = await file.readAsBytes();
  //     UploadTask uploadTask = ref.putData(myfile);
  //     TaskSnapshot snap = await uploadTask;
  //     String downloadUrl = await snap.ref.getDownloadURL();
  //     return downloadUrl;
  //   }
  //   return '';
  // }

  // Future<void> pickImage() async {
  //   final imagePicker = ImagePicker();
  //   final pickedImage =
  //       await imagePicker.pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     final filepath = pickedImage.path;
  //     controller.file = pickedImage;
  //     controller.filepath.value = filepath;
  //   }
  // }
}
