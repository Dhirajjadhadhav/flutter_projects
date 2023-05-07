import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/models/message.dart';

class APIs {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing cloud firebase database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for accessing cloud firebase database
  static FirebaseStorage storage = FirebaseStorage.instance;

  static late ChatUser me;
  //to return current user
  static User get user => auth.currentUser!;
  //for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        log('My Data: ${user.data()}');
      } else {
        await CreateUser().then((value) => getSelfInfo());
      }
    });
  }

  //for creating a new user
  static Future<void> CreateUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey i'm using we chat!",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: "");
    return (await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.toJson()));
  }

  //for getting all user from firebase database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection("users")
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .update({'name': me.name, 'about': me.about});
  }

  //update profile picture of user
  static Future<void> UpdateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    log("Extension:$ext");
    //storage file ref with path
    final ref = await storage.ref().child("profile_pictures/${user.uid}.$ext");

    //upload image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) async {
      log("Data Transferred: ${p0.bytesTransferred / 1000}kb");
    });

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore.collection("users").doc(auth.currentUser!.uid).update({
      'image': me.image,
    });
  }

  /************* Chat Screen Related APIs *************/
  //chats(collection) --> conversation_id (doc) -->messages (collection) -->message(doc)
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //for getting all message of specific conversation from firebase database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .snapshots();
  }

  //for sending message
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    //message sending time  (also used as  id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        sent: time,
        fromId: user.uid);
    final ref = firestore
        .collection('chats/${getConversationId(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  //update read status of message
  static Future<void> UpdateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('send', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = await storage.ref().child(
        "images/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext");

    //upload image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) async {
      log("Data Transferred: ${p0.bytesTransferred / 1000}kb");
    });

    //updating image in firestore database
    final imageURl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageURl, Type.image);
  }
}
