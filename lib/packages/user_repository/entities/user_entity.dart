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

  MyUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.nickname,
    required this.followers,
    required this.following,
    this.picture,
    this.backgroundPicture
  });

  // Метод для преобразования сущности в документ для базы данных
  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'picture': picture,
      'name': name,
      'followers': followers,
      'following': following,
      'backgroundPicture': backgroundPicture
    };
  }

  // Метод для создания экземпляра MyUserEntity из Map
  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      id: doc['id'] as String,
      email: doc['email'] as String,
      nickname: doc['nickname'] as String,
      picture: doc['picture'] as String?,
      name: doc['name'] as String,
      followers: List<String>.from(doc['followers'] ?? []),
      following: List<String>.from(doc['following'] ?? []),
      backgroundPicture: doc['backgroundPicture'] as String?
     );
  }

  @override
  List<Object?> get props =>
      [id, email, nickname, picture, name, followers, following, backgroundPicture];

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
      backgroundPicture: backgroundPicture
    }''';
  }
}
