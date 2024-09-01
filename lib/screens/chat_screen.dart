import 'package:flutter/material.dart';
import 'package:flash_chat_tutorial/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String? messageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    messageStream();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      print('fromSnapshot');
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      try {
                        var data = {
                          'text': messageText,
                          'sender': loggedInUser!.email,
                          'date_added': FieldValue.serverTimestamp()
                        };
                        print('data is : $data');
                        if (data != null) {
                          _firestore.collection('messages').add(data);
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('date_added').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          ); // You can replace this with any other widget.
        } else {
          final messageDocs = snapshot.data!.docs;
          List<MessageBubbles> messageWidgets = [];

          for (var i = 0; i < messageDocs.length; i++) {
            DocumentSnapshot snap = messageDocs[i];
            final messageText = snap['text'];
            final sender = snap['sender'];
            final currentUser = loggedInUser!.email;

            if (currentUser == sender) {}
            if (messageText != null) {
              messageWidgets.add(
                MessageBubbles(
                    messageText: messageText,
                    sender: sender,
                    isMe: currentUser == sender),
              );
            }
          }

          return Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageWidgets,
            ),
          );
        }
      },
    );
  }
}

class MessageBubbles extends StatelessWidget {
  final String? messageText;
  final String? sender;
  final bool? isMe;

  MessageBubbles({this.messageText, this.sender, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender.toString(),
            style: TextStyle(fontSize: 12.0, color: Colors.white54),
          ),
          Material(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe! ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Text(
                messageText.toString(),
                style: TextStyle(
                    fontSize: 15.0, color: isMe! ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
