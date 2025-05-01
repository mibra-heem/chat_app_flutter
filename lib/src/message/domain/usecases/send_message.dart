import 'package:equatable/equatable.dart';
import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/message/domain/repo/message_repo.dart';

class SendMessage extends UseCaseWithParams<void, SendMessageParams> {
  const SendMessage(this._repo);

  final MessageRepo _repo;

  @override
  RFuture<void> call(SendMessageParams params) => _repo.sendMessage(
    user: params.user,
    chat: params.chat,
    message: params.message,
  ); 
}

class SendMessageParams extends Equatable{

  const SendMessageParams({
    required this.user,
    required this.chat,
    required this.message,

  });

  final LocalUser user;
  final Chat chat;
  final String message;

  @override
  List<Object?> get props => [user, chat];
  
}
