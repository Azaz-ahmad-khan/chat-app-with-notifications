//lib\core\models\message_model.dart
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
    final vM = context.read<ChatViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vM.setUnreadCountToZero(
        FirebaseAuth.instance.currentUser!.uid,
        widget.user['userId'],
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user['name']),
        backgroundColor: Colors.red.shade200,
        centerTitle: true,
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
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error Occurred While Loading Data'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Messages Yet'));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data![index];
                    final isCurrentUser =
                        message['userId'] ==
                        FirebaseAuth.instance.currentUser!.uid;

                    return Padding(
                      padding: isCurrentUser
                          ? const EdgeInsets.only(left: 10, right: 50, top: 10)
                          : const EdgeInsets.only(right: 10, left: 50, top: 10),
                      child: Align(
                        alignment: isCurrentUser
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? Colors.green.shade400
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(message['message']),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                const SizedBox(width: 2),
                Consumer<ChatViewModel>(
                  builder: (context, vM, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                      ),
                      child: IconButton(
                        onPressed: vM.isLoading
                            ? null
                            : () async {
                                if (vM.messageController.text.isNotEmpty) {
                                  final message = MessageModel(
                                    message: vM.messageController.text,
                                    userId:
                                        FirebaseAuth.instance.currentUser!.uid,
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
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Icon(Icons.arrow_upward),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
