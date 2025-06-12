import 'package:equatable/equatable.dart';

class Message extends Equatable{

  const Message({
    required this.msg,
    required this.msgTime,
    required this.senderId,
    required this.recieverId,
    this.isSeen = false,
    
  });

  Message.empty() : this(
    msg: '',
    msgTime: DateTime.now(),
    senderId: '',
    recieverId: '',
  );

  final String senderId;
  final String recieverId;
  final String msg;
  final DateTime msgTime;
  final bool isSeen;

  @override
  List<Object?> get props => [
    senderId, recieverId,
    msg, msgTime, 
  ];

  @override
  String toString(){
    return 'Message{msg : $msg, msgTime: $msgTime, isSeen: $isSeen}';
  }
}
