import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/message/domain/entity/message.dart';

class MessageModel extends Message{
  const MessageModel({
    required super.msg, 
    required super.msgTime, 
    required super.senderId, 
    required super.recieverId, 
    required super.senderName, 
    required super.recieverName, 
    required super.senderEmail, 
    required super.recieverEmail,
    required super.senderImage, 
    required super.recieverImage, 
    
  });

  MessageModel.empty() : super.empty();

  
  MessageModel.fromMap(DataMap map)
    : super(
        senderId: map['senderId'] as String,
        recieverId: map['recieverId'] as String,
        senderName: map['senderName'] as String,
        recieverName: map['recieverName'] as String,
        senderEmail: map['senderEmail'] as String,
        recieverEmail: map['recieverEmail'] as String,
        senderImage: map['senderImage'] as String,
        recieverImage: map['recieverImage'] as String,
        msg: map['msg'] as String,
        msgTime: (map['msgTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );

  MessageModel copyWith({
    String? senderId,
    String? recieverId,
    String? senderName,
    String? recieverName,
    String? senderEmail,
    String? recieverEmail,
    String? senderImage,
    String? recieverImage,
    String? msg,
    DateTime? msgTime,
    int? msgNum,
  }) {
    return MessageModel(
      senderId: senderId ?? this.senderId,
      recieverId: recieverId ?? this.recieverId,
      senderName: senderName ?? this.senderName,
      recieverName: recieverName ?? this.recieverName,
      senderEmail: senderEmail ?? this.senderEmail,
      recieverEmail: recieverEmail ?? this.recieverEmail,
      senderImage: senderImage ?? this.senderImage,
      recieverImage: recieverImage ?? this.recieverImage,
      msg: msg ?? this.msg,
      msgTime: msgTime ?? this.msgTime,

    );
  }

  DataMap toMap() {
    return {
      'senderId': senderId,
      'recieverId': recieverId,
      'senderName': senderName,
      'recieverName': recieverName,
      'senderEmail': senderEmail,
      'recieverEmail': recieverEmail,
      'senderImage': senderImage,
      'recieverImage': recieverImage,
      'msg': msg,
      'msgTime': FieldValue.serverTimestamp(),
    };
  }
  
}
