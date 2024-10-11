import 'package:flutter_x/packages/user_repository/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

class MyUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String nickname;
  String? picture;
  List<String> followers;
  List<String> following;
  String? backgroundPicture;

  MyUser({
    required this.id,
    required this.name,
    required this.email,
    required this.nickname,
    required this.followers,
    required this.following,
    this.picture,
    this.backgroundPicture
  });

  // Статическая переменная для пустого пользователя
  static var empty = MyUser(
      id: '',
      nickname: '',
      email: '',
      picture: '',
      name: '',
      followers: [],
      following: [],
      backgroundPicture: ''
      );

  MyUser copyWith({
    String? id,
    String? email,
    String? nickname,
    String? picture,
    String? name,
    List<String>? followers,
    List<String>? following,
    String? backgroundPicture,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      picture: picture ?? this.picture,
      name: name ?? this.name,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      backgroundPicture: backgroundPicture ?? this.backgroundPicture
    );
  }

  // Геттеры для проверки пустоты
  bool get isEmpty => this == MyUser.empty;
  bool get isNotEmpty => this != MyUser.empty;

  // Метод для преобразования в UserEntity

  MyUserEntity toEntity() {
    return MyUserEntity(
        id: id,
        email: email,
        nickname: nickname,
        picture: picture,
        name: name,
        followers: followers,
        following: following,
        backgroundPicture: backgroundPicture
        );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      id: entity.id,
      email: entity.email,
      nickname: entity.nickname,
      picture: entity.picture,
      name: entity.name,
      followers: entity.followers,
      following: entity.following,
      backgroundPicture: entity.backgroundPicture
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
      nickname: $nickname
      picture: $picture
      name: $name
      followers: $followers
      following: $following
      backgroundPicture: $backgroundPicture
    }''';
  }
}
