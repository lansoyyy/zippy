class Message {
  final String text;
  final String senderName;
  final String time;
  final bool isSentByMe;

  Message({
    required this.text,
    required this.senderName,
    required this.time,
    required this.isSentByMe,
  });
}
