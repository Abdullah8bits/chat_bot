import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ChatUser user = ChatUser(id: "1", firstName: "Abdullah", lastName: "Khan");
  ChatUser bot = ChatUser(id: "2", firstName: "Abdullah", lastName: "ai");
  List<ChatMessage> messages = [];
  List<ChatUser> typing = [];
  final apiendpoint =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBrJ2ndZCy3LdTj7QiXeZ_stOJZ_fCrx_s";
  final header = {'Content-Type': 'application/json'};

  getdata(ChatMessage m) async {
    typing.add(bot);
    messages.insert(0, m);
    setState(() {});
    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(apiendpoint), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        print(result['candidates'][0]['content']['parts'][0]['text']);
        ChatMessage botmessage = ChatMessage(
            text: result['candidates'][0]['content']['parts'][0]['text'],
            user: bot,
            createdAt: DateTime.now());
        messages.insert(0, botmessage);
        setState(() {});
      } else {
        print("error occured");
      }
    }).catchError((e) {});
    typing.remove(bot);
  }

  //i use this as a help for endpoint and header and for data also
  // curl \
  // -H 'Content-Type: application/json' \
  // -d '{"contents":[{"parts":[{"text":"Write a story about a magic backpack"}]}]}' \
  // -X POST https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=YOUR_API_KEY

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Colors.white,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Ask Me Anything',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert,
                  size: 25,
                  color: Colors.white,
                ))
          ],
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: Colors.grey[850]),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 78, 78, 78),
        width: 250,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                  child: Text(
                "AI",
                style: TextStyle(fontSize: 30, color: Colors.white),
              )),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(
                Icons.image,
                color: Colors.white,
              ),
              title: const Text(
                ' Image Generation  ',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.text_fields,
                color: Colors.white,
              ),
              title: const Text(
                ' Text Generation ',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.cabin,
                color: Colors.white,
              ),
              title: const Text(
                ' Story Generation ',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ), //
      body: DashChat(
          typingUsers: typing,
          currentUser: user,
          onSend: (ChatMessage m) {
            getdata(m);
          },
          messages: messages),
    );
  }
}
