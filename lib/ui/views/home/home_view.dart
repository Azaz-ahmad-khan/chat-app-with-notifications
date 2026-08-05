//lib\ui\views\home\home_view.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noti_chat/ui/views/chat/chat_view.dart';
import 'package:noti_chat/ui/views/home/home_view_model.dart';
import 'package:noti_chat/ui/views/signIN/sign_in_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, vM, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Home'),
            centerTitle: true,
            backgroundColor: Colors.red.shade300,
            actions: [
              IconButton(
                onPressed: () async {
                  final logout = await vM.logOut();
                  if (logout) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignInView()),
                      (route) => false,
                    );
                  }
                },
                icon: Icon(Icons.logout),
              ),
            ],
          ),
          body: StreamBuilder(
            stream: vM.getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error occured while Loading Data'));
              }
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final user = snapshot.data![index];
                    if (user['email'] ==
                        FirebaseAuth.instance.currentUser!.email) {
                      return Container();
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatView(user: user),
                            ),
                          );
                        },
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10),
                          ),
                          tileColor: Colors.grey.shade200,
                          leading: CircleAvatar(
                            child: Text((index + 1).toString()),
                          ),
                          title: Text(user['name']),
                          trailing: StreamBuilder(
                            stream: vM.getUnReadCount(
                              FirebaseAuth.instance.currentUser!.uid,
                              user['userId'],
                            ),
                            builder: (context, snapshot) {
                              final count = snapshot.data ?? 0;
                              if (count == 0) return SizedBox();

                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    count > 99 ? '99+' : count.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: .bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return Center(child: Text('No Data in the Snap shot'));
            },
          ),
        );
      },
    );
  }
}
