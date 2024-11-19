// lib/agencyPages/messagePage.dart

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'chatScreen.dart';

class AgencyChats extends StatefulWidget {
  const AgencyChats({Key? key}) : super(key: key);

  @override
  State<AgencyChats> createState() => _AgencyChatsState();
}

class _AgencyChatsState extends State<AgencyChats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#1E9CFF"),
        // leading: Image.asset("assets/agencyImages/Menu.png"),
        title: Text(
          "Messages",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("assets/agencyImages/avatar.png"),
                  ),
                  title: Text(
                    "Lassade Mrabet",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "hello, how are you....",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "2",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
