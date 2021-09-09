import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codespot/config/paths.dart';
import 'package:equatable/equatable.dart';

import 'package:codespot/models/models.dart';

class Message extends Equatable {
  final String text;
  final User sender;
  final User me;
  final DateTime datetime;
  final bool messageRead;
  final String messageId;
  final String convercationId;

  const Message({
    required this.text,
    required this.sender,
    required this.me,
    required this.datetime,
    required this.messageRead,
    required this.messageId,
    required this.convercationId,
  });

  Message copyWith({
    String? text,
    User? sender,
    User? me,
    DateTime? timestamp,
    bool? messageRead,
    String? messageId,
    String? convercationId,
  }) {
    return Message(
      text: text ?? this.text,
      sender: sender ?? this.sender,
      me: me ?? this.me,
      datetime: timestamp ?? datetime,
      messageRead: messageRead ?? this.messageRead,
      messageId: messageId ?? this.messageId,
      convercationId: convercationId ?? this.convercationId,
    );
  }

  @override
  bool get stringify => true;

  Map<String, dynamic> toDocument() {
    return {
      'text': text,
      'sender': toDocumentRefrence(sender),
      'me': toDocumentRefrence(me),
      'timestamp': datetime.millisecondsSinceEpoch,
      'messageRead': messageRead,
      'convercationId': convercationId,
    };
  }

  static Future<Message?> fromDocument(DocumentSnapshot snapshot) async {
    final data = snapshot.data() as Map<String, dynamic>;
    final senderref = data["sender"] as DocumentReference?;
    final meRef = data["me"] as DocumentReference?;

    if (senderref != null && meRef != null) {
      final senderDoc = await senderref.get();
      final meDoc = await meRef.get();

      if (senderDoc.exists && meDoc.exists) {
        return Message(
          text: data['text'] ?? "",
          sender: User.fromDocument(senderDoc),
          me: User.fromDocument(meDoc),
          datetime: (data["timestamp"] as Timestamp).toDate(),
          messageRead: data["messageRead"] ?? false,
          messageId: data["messageId"] ?? "",
          convercationId: data["convercationId"] ?? "",
        );
      }
    }
  }

  static DocumentReference toDocumentRefrence(User user) {
    return FirebaseFirestore.instance.collection(Paths.users).doc(user.uid);
  }

  @override
  List<Object> get props {
    return [
      text,
      sender,
      me,
      datetime,
      messageRead,
      messageId,
      convercationId,
    ];
  }
}