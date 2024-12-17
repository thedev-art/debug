import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amanuel_glass/helper/colors.dart';
import 'package:amanuel_glass/view/components/custom_snackbar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../base/edit_card.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? phoneNumber = Get.find<AuthController>().userPhone;
    // final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.find<AuthController>().filepath.value = '';
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.black),
        title: Text(
          'edit_profile'.tr,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 20, top: 8, bottom: 8),
              child: Icon(Icons.more_vert, color: Colors.black),
            ),
            onSelected: (String result) {
              if (result == 'delete_account') {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: SizedBox(
                            height: 150,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    'Are you sure you want to Delete your account?',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                shadowColor: Colors.transparent,
                                                minimumSize: const Size(80, 35),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                )),
                                            child: Text('no'.tr)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              AuthController.instance
                                                  .clearData();
                                              showCustomSnackBar(
                                                  'Account deleted');
                                            },
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                shadowColor: Colors.transparent,
                                                minimumSize: const Size(80, 35),
                                                backgroundColor:
                                                    Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                )),
                                            child: Text(
                                              'yes'.tr,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ),
                                    ],
                                  )
                                ]),
                          ),
                        ));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'delete_account',
                child: Text(
                  'delete_account'.tr,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          Text("Edit profile ")
          // if (phoneNumber != null)
          //   StreamBuilder<DocumentSnapshot>(
          //     stream: FirebaseFirestore.instance
          //         .collection('users')
          //         .doc(phoneNumber)
          //         .snapshots(),
          //     builder: (BuildContext context,
          //         AsyncSnapshot<DocumentSnapshot> snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return Center(
          //           child: CircularProgressIndicator(
          //             color: MyColors.primary,
          //           ),
          //         );
          //       }
          //       if (!snapshot.hasData || !snapshot.data!.exists) {
          //         return const Center(
          //           child: Text(
          //             "User not found",
          //             style: TextStyle(
          //               color: Color.fromARGB(184, 138, 138, 138),
          //             ),
          //           ),
          //         );
          //       }
          //       if (snapshot.hasError) {
          //         return const Center(
          //           child: Text(
          //             "Unable to get user data",
          //             style: TextStyle(
          //               color: Color.fromARGB(184, 138, 138, 138),
          //             ),
          //           ),
          //         );
          //       }
          //       return Flexible(
          //         child: EditCard(
          //           snap: snapshot.data,
          //         ),
          //       );
          //     },
          //   ),
        ],
      ),
    );
  }

  // void _deleteAccount(BuildContext context, FirebaseAuth auth) async {
  //   try {
  //     User? user = auth.currentUser;
  //     if (user != null) {
  //       await user.delete();
  //       if (context.mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Account deleted successfully')),
  //         );
  //       }
  //     } else {
  //       if (context.mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('No user signed in')),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to delete account: $e')),
  //       );
  //     }
  //   }
  // }
}
