import 'package:equatable/equatable.dart';

class Message extends Equatable{

  const Message({
    required this.msg,
    required this.msgTime,
    required this.senderId,
    required this.recieverId,
    this.uid,
    this.isSeen = false,
    
  });

  Message.empty() : this(
    msg: '',
    msgTime: DateTime.now(),
    senderId: '',
    recieverId: '',
  );

  final String? uid; 
  final String senderId;
  final String recieverId;
  final String msg;
  final DateTime msgTime;
  final bool isSeen;

  @override
  List<Object?> get props => [
    uid,
    senderId, recieverId,
    msg, msgTime, 
  ];

  @override
  String toString(){
    return 'Message{uid: $uid, msg: $msg, msgTime: $msgTime, isSeen: $isSeen}';
  }
}
