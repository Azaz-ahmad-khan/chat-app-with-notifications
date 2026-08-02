import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noti_chat/core/models/message_model.dart';
import 'package:noti_chat/ui/views/chat/chat_view_model.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  final Map<String, dynamic> user;
  const ChatView({super.key, required this.user});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewModel>(
      builder: (context, vM, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.user['email']),
            backgroundColor: Colors.red.shade200,
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: vM.getMessages(
                    FirebaseAuth.instance.currentUser!.uid,
                    widget.user['userId'],
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error Occured While Loading Data'),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No Messages Yet'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final message = snapshot.data![index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(message['message']),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: vM.messageController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          if (vM.messageController.text.isNotEmpty) {
                            final message = MessageModel(
                              message: vM.messageController.text,
                              userId: FirebaseAuth.instance.currentUser!.uid,
                              sendingTime: DateTime.now(),
                            );
                            await vM.sendMessage(
                              FirebaseAuth.instance.currentUser!.uid,
                              widget.user['userId'],
                              message,
                            );
                            vM.messageController.clear();
                          }
                        },
                        icon: vM.isLoading
                            ? CircularProgressIndicator()
                            : Icon(Icons.arrow_upward),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
