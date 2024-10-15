import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String nickname;
  final String? picture;
  List<String> followers;
  List<String> following;
  final String? backgroundPicture;
  List<MyUserEntity> chatguests; 
  final String? bio; 

  MyUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.nickname,
    required this.followers,
    required this.following,
    this.picture,
    this.backgroundPicture,
    this.chatguests = const [], 
    this.bio, 
  });

 
  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'picture': picture,
      'name': name,
      'followers': followers,
      'following': following,
      'backgroundPicture': backgroundPicture,
      'chatguests': chatguests.map((guest) => guest.toDocument()).toList(), 
      'bio': bio, 
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      id: doc['id'] as String,
      email: doc['email'] as String,
      nickname: doc['nickname'] as String,
      picture: doc['picture'] as String?,
      name: doc['name'] as String,
      followers: List<String>.from(doc['followers'] ?? []),
      following: List<String>.from(doc['following'] ?? []),
      backgroundPicture: doc['backgroundPicture'] as String?,
      chatguests: (doc['chatguests'] as List<dynamic>?)?.map((guest) => MyUserEntity.fromDocument(guest)).toList() ?? [], 
      bio: doc['bio'] as String?, 
    );
  }
  
  @override
  List<Object?> get props => [
    id, email, nickname, picture, name, followers, following, backgroundPicture, chatguests, bio
  ];


  @override
  String toString() {
    return '''UserEntity: {
      id: $id
      email: $email
      name: $nickname
      picture: $picture
      name: $name
      followers: $followers
      following: $following
      backgroundPicture: $backgroundPicture
    }''';
  }
}
