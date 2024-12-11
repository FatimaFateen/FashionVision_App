class Chat {
  final String receiver;
  final String sender;
  final List<Messages> messages;
  final String id;
  final String receiverName;
  final String senderName;
  Chat(
      {required this.receiver,
      required this.sender,
      required this.messages,
      required this.id,
      required this.receiverName,
      required this.senderName});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'receiver': receiver,
      'sender': sender,
      'messages': messages.map((x) => x.toMap()).toList(),
      'id': id,
      'receiverName': receiverName,
      'senderName': senderName,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      receiver: map['receiver'] as String,
      sender: map['sender'] as String,
      messages: List<Messages>.from(
        (map['messages']).map<Messages>(
          (x) => Messages.fromMap(x as Map<String, dynamic>),
        ),
      ),
      id: map['id'] as String,
      receiverName: map['receiverName'] as String,
      senderName: map['senderName'] as String,
    );
  }
}

class Messages {
  final String message;
  final String uid;
  final int time;
  Messages({
    required this.message,
    required this.uid,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'message': message, 'uid': uid, 'time': time};
  }

  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(
      message: map['message'] as String,
      uid: map['uid'] as String,
      time: map['time'] as int,
    );
  }
}
