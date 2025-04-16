import 'package:equatable/equatable.dart';

class Chat extends Equatable{

  const Chat({
    required this.id,
    required this.name,
    required this.image,
    required this.email,

  });

  const Chat.empty() : this(
    id: '',
    name: '',
    image: '',
    email: '',
  );

  final String id;
  final String name;
  final String image;
  final String email;


  @override
  List<Object?> get props => [ id, name, image, email];

  @override
  String toString(){
    return 'Chat{id : $id, name : $name}';
  }
}
