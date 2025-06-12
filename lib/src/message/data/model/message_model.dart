import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/message/domain/entity/message.dart';

class MessageModel extends Message{
  const MessageModel({
    required super.msg, 
    required super.msgTime, 
    required super.senderId, 
    required super.recieverId, 
    super.isSeen,
  });

  MessageModel.empty() : super.empty();

  
  MessageModel.fromMap(DataMap map)
    : super(
        senderId: map['senderId'] as String,
        recieverId: map['recieverId'] as String,
        msg: map['msg'] as String,
        msgTime: (map['msgTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
        isSeen: map['isSeen'] as bool,
      );

  MessageModel copyWith({
    String? senderId,
    String? recieverId,
    String? msg,
    DateTime? msgTime,
    bool? isSeen,
  }) {
    return MessageModel(
      senderId: senderId ?? this.senderId,
      recieverId: recieverId ?? this.recieverId,
      msg: msg ?? this.msg,
      msgTime: msgTime ?? this.msgTime,
      isSeen: isSeen ?? this.isSeen,
    );
  }

  DataMap toMap() {
    return {
      'senderId': senderId,
      'recieverId': recieverId,
      'msg': msg,
      'msgTime': FieldValue.serverTimestamp(),
      'isSeen': isSeen,
    };
  }
  
}
