import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/models/chat_user.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for string all messages
  List<Message> _list = [];

  //for handling message text changes
  final _textController = TextEditingController();

  //for storing value of showing or hiding emoji
  bool _showEmoji = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          //if emoji are shown & back button is pressed then hide emoji s
          //or else simple close Current screen on back  button click
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            backgroundColor: Color.fromARGB(255, 234, 248, 255),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: APIs.getAllMessages(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          //if data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const SizedBox();
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            _list = data
                                    ?.map((e) => Message.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                  itemCount: _list.length,
                                  padding:
                                      EdgeInsets.only(top: mq.height * 0.01),
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return MessageCard(message: _list[index]);
                                  });
                            } else {
                              return Center(
                                child: Text(
                                  "Say Hii! 👋",
                                  style: TextStyle(fontSize: 20),
                                ),
                              );
                            }
                        }
                      }),
                ),
                //show input field
                _chatInput(),

                //show emoji on keyboard emoji button click & vice versa

                if (_showEmoji)
                  SizedBox(
                    height: mq.height * 0.35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //app bar widget
  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(children: [
        //back buttton
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black54,
        ),
        //user profile
        ClipRRect(
          borderRadius: BorderRadius.circular(mq.height * .033),
          child: CachedNetworkImage(
            width: mq.height * .05,
            height: mq.height * .05,
            imageUrl: widget.user.image,
            errorWidget: (context, url, error) => CircleAvatar(
              child: Icon(CupertinoIcons.person),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        //user name and last seen
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //user name
            Text(
              widget.user.name,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
            ),
            //for adding some space
            SizedBox(
              height: 2,
            ),
            //lasts seen time of user
            Text(
              "Last seen Not available",
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            )
          ],
        )
      ]),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * 0.01, horizontal: mq.width * 0.025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        _showEmoji = !_showEmoji;
                      });
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      size: 25,
                    ),
                    color: Colors.blueAccent,
                  ),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      setState(() {
                        _showEmoji = !_showEmoji;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  //Pick image from gallery button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.image,
                      size: 26,
                    ),
                    color: Colors.blueAccent,
                  ),

                  //take image from camera button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        log('Image path:${image.path} -- MimiType:${image.mimeType}');

                        await APIs.sendChatImage(widget.user, File(image.path));
                      }
                    },
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      size: 26,
                    ),
                    color: Colors.blueAccent,
                  ),
                  //adding some space
                  SizedBox(
                    width: mq.width * 0.02,
                  ),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text, Type.text);
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: CircleBorder(),
            color: Colors.green,
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
