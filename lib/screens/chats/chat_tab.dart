import 'package:flutter/material.dart';
import 'package:zippy/models/chat_model.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/text_widget.dart';

class ChatTab extends StatefulWidget {
  bool? ingeneral;

  ChatTab({
    super.key,
    this.ingeneral = false,
  });

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  List<Message> messages = [
    Message(
      text: 'Hello!',
      senderName: 'John Doe',
      time: '10:00 AM',
      isSentByMe: false,
    ),
    Message(
      text: 'Hi there!',
      senderName: 'Jane Smith',
      time: '10:05 AM',
      isSentByMe: true,
    ),
    Message(
      text: 'How are you?',
      senderName: 'John Doe',
      time: '10:10 AM',
      isSentByMe: false,
    ),
    Message(
      text: 'I\'m good, thanks!',
      senderName: 'Jane Smith',
      time: '10:15 AM',
      isSentByMe: true,
    ),
    Message(
      text: 'What about you?',
      senderName: 'John Doe',
      time: '10:20 AM',
      isSentByMe: false,
    ),
    Message(
      text: 'I\'m doing well.',
      senderName: 'Jane Smith',
      time: '10:25 AM',
      isSentByMe: true,
    ),
  ];
  final msg = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 75,
              color: secondary,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      minRadius: 27,
                      maxRadius: 27,
                      backgroundColor: grey,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: 'ENGLISH 101',
                          fontSize: 18,
                          fontFamily: 'Bold',
                          color: primary,
                        ),
                        SizedBox(
                          width: 175,
                          child: TextWidget(
                            text: 'Fundamentals of english...',
                            fontSize: 14,
                            fontFamily: 'Regular',
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                    const Expanded(
                      child: SizedBox(
                        width: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageWidget(message: messages[index]);
              },
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    size: 35,
                    color: primary,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  child: const Icon(
                    Icons.image_outlined,
                    size: 35,
                    color: primary,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 275,
                  height: 50,
                  child: TextFormField(
                    style: const TextStyle(
                      fontFamily: 'Regular',
                      fontSize: 14,
                      color: primary,
                    ),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      filled: true,
                      fillColor: grey.withOpacity(0.75),
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                      hintStyle: const TextStyle(
                        fontFamily: 'Regular',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      hintText: 'Write something...',
                      border: InputBorder.none,
                    ),
                    controller: msg,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!message.isSentByMe)
            CircleAvatar(
              child: Text(message.senderName[0]),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: message.isSentByMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  message.senderName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Bold'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: message.isSentByMe ? Colors.blue : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    message.text,
                    style: TextStyle(
                        color: message.isSentByMe ? Colors.white : Colors.black,
                        fontFamily: 'Regular'),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.time,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey, fontFamily: 'Regular'),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          if (message.isSentByMe)
            CircleAvatar(
              child: Text(
                message.senderName[0],
                style: const TextStyle(fontFamily: 'Bold'),
              ),
            ),
        ],
      ),
    );
  }
}
