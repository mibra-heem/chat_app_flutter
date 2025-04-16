import 'package:equatable/equatable.dart';
import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/message/domain/repo/message_repo.dart';

class SendMessage extends UseCaseWithParams<void, SendMessageParams> {
  const SendMessage(this._repo);

  final MessageRepo _repo;

  @override
  RFuture<void> call(SendMessageParams params) => _repo.sendMessage(
    user: params.user,
    contact: params.contact,
    message: params.message,
  ); 
}

class SendMessageParams extends Equatable{

  const SendMessageParams({
    required this.user,
    required this.contact,
    required this.message,

  });

  final LocalUser user;
  final Contact contact;
  final String message;

  @override
  List<Object?> get props => [user, contact];
  
}
