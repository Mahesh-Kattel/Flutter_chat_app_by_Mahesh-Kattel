import 'package:chatapp/Pages/SignupPage.dart';
import 'package:chatapp/Pages/chatpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  onTapp() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.exit_to_app_sharp),
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const SignupPage();
          }));
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              SearchFriends(),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchFriends extends StatefulWidget {
  const SearchFriends({super.key});

  @override
  State<SearchFriends> createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  late FocusNode myfocusnode;
  String query = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myfocusnode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black26,
            ),
            height: 50,
            child: TextField(
              focusNode: myfocusnode,
              onTap: () {
                setState(() {});
              },
              onSubmitted: (a) {
                setState(() {});
              },
              onChanged: (a) {
                setState(() {
                  query = a;
                });
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Friend Here..........'),
            ),
          ),
          if (myfocusnode.hasFocus)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black54),
                height: 200,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: ((context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data?.docs
                                .where((element) =>
                                    element.id !=
                                        FirebaseAuth
                                            .instance.currentUser?.uid &&
                                    element['fullname']
                                        .toString()
                                        .toLowerCase()
                                        .contains(query.toLowerCase()))
                                .length,
                            itemBuilder: ((context, index) {
                              var data = snapshot.data?.docs
                                  .where((element) =>
                                      element.id !=
                                          FirebaseAuth
                                              .instance.currentUser?.uid &&
                                      element['fullname']
                                          .toString()
                                          .toLowerCase()
                                          .contains(query.toLowerCase()))
                                  .toList();
                              return FriendsCard(
                                document: data![index],
                              );
                            }),
                          )
                        : Container();
                  }),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class FriendsCard extends StatelessWidget {
  QueryDocumentSnapshot document;
  FriendsCard({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white10,
        ),
        child: ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: ((context) {
              return ChatPage(
                uid: document.id,
              );
            })));
          },
          leading: CircleAvatar(
              backgroundImage: NetworkImage(document['profilepic'])),
          title: Text(document['fullname']),
        ),
      ),
    );
  }
}
