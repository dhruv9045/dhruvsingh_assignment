import 'package:assignment/functions/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';

import '../functions/authFunctions.dart';
import '../functions/firebaseFunctions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                authController.signOut();
              },
              icon: Icon(Icons.logout_outlined))
        ],
        title: Text('Home'),
      ),
      body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
        stream: FirestoreServices().getFirebaseUser(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Loading...'));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No User Found"),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.only(top: 8),
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              var name = data['name'];
              var fcm = data['fcm'];
              var email = data['email'];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  style: ListTileStyle.list,
                  // leading: ClipRRect(
                  //     borderRadius: BorderRadius.circular(50),
                  //     child: Image.network(profileImg)),
                  title: Text(name),
                  subtitle: Text(email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () async {
                            await NotificationFunction()
                                .sendNotification(fcm: fcm);
                          },
                          icon: Icon(
                            Icons.notification_important_sharp,
                            color: Colors.blue,
                          )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      )),
    );
  }
}
