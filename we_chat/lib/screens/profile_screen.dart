import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/helper/dialogs.dart';
import 'package:we_chat/screens/auth/login_screen.dart';
import '../api/apis.dart';

import '../main.dart';
import '../models/chat_user.dart';

//profile screen -- to show signed in user info
class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //app bar
        appBar: AppBar(
          title: Text("Profile Screen"),
        ),
        //folating button to add new user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () async {
              //for showing Progress dialog
              Dialogs.showProgressBar(context);

              //sign out from app
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  //for hiding progress dialog
                  Navigator.pop(context);

                  //for moving to home screen
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                });
              });
            },
            icon: Icon(Icons.logout),
            label: Text("Logout"),
          ),
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //for adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * 0.03,
                  ),

                  //user profile picture
                  Stack(
                    children: [
                      //profile picture
                      _image != null
                          ?

                          //local image
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: Image.file(
                                File(_image!),
                                width: mq.height * 0.2,
                                height: mq.height * 0.2,
                                fit: BoxFit.cover,
                              ),
                            )

                          //iamge from server
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: CachedNetworkImage(
                                width: mq.height * 0.2,
                                height: mq.height * 0.2,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                //placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  child: Icon(CupertinoIcons.person),
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _shorBottomSheet();
                          },
                          shape: CircleBorder(),
                          color: Colors.white,
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                  //for adding some space
                  SizedBox(
                    height: mq.height * 0.03,
                  ),
                  Text(
                    widget.user.email,
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),

                  //for adding some space
                  SizedBox(
                    height: mq.height * 0.05,
                  ),

                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "required field",
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: "eg Dhiraj Jadhav",
                        label: Text("Name")),
                  ),

                  SizedBox(
                    height: mq.height * 0.02,
                  ),

                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "required field",
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: "eg don't need memories",
                        label: Text("About")),
                  ),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        minimumSize: Size(mq.width * 0.5, mq.height * 0.06)),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          Dialogs.showSnackbar(
                              context, "Profile Updated Successfully!");
                        });
                      }
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 28,
                    ),
                    label: Text(
                      "UPADTE",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //bottom sheet for picking a Profile pitcture for user
  void _shorBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: mq.height * 0.03, bottom: mq.height * 0.05),
            children: [
              //pick profile picture label
              Text(
                "Pick Profile picture",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),

              SizedBox(
                height: mq.height * 0.02,
              ),
              //button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick form gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(mq.width * 0.3, mq.height * 0.15),
                          shape: CircleBorder()),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image path:${image.path} -- MimiType:${image.mimeType}');
                          //for hiding buttom sheet
                          setState(() {
                            _image = image.path;
                          });
                          APIs.UpdateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset("images/add_image.png")),
                  //take a picture from camera
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(mq.width * 0.3, mq.height * 0.15),
                          shape: CircleBorder()),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image path:${image.path} -- MimiType:${image.mimeType}');
                          //for hiding buttom sheet
                          setState(() {
                            _image = image.path;
                          });
                          APIs.UpdateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset("images/camera.png")),
                ],
              )
            ],
          );
        });
  }
}
