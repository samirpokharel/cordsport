import 'package:codespot/models/models.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  final User user;

  const ChatRoom({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.codeName)),
      body: Column(
        children: const [Spacer()],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          height: 60,
          width: double.infinity,
          child: Row(
            children: [
              // TODO: implemnt image test field
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Message",
                  ),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send))
            ],
          ),
        ),
      ),
    );
  }
}