// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_x/packages/user_repository/entities/user_entity.dart';
import 'package:flutter_x/packages/user_repository/models/user_model.dart';

class PostEntity extends Equatable {
  String postId;
  String post;
  DateTime createdAt;
  MyUser myUser;
  String? postImage;
  int likes;
  List<String> likedBy;
  int commentCount;

  PostEntity({
    required this.postId,
    required this.post,
    required this.createdAt,
    required this.myUser,
    this.postImage,
    required this.likes,
    required this.likedBy,
    required this.commentCount
  });

  Map<String, Object?> toDocument() {
    return {
      'postId': postId,
      'post': post,
      'createdAt': createdAt,
      'myUser': myUser.toEntity().toDocument(),
      'postImage': postImage,
      'likes': likes,
      'likedBy': likedBy,
      'commentCount': commentCount
    };
  }

  
  static PostEntity fromDocument(Map<String, dynamic> doc) {
    return PostEntity(
      postId: doc['postId'] as String,
      post: doc['post'] as String,
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      myUser: MyUser.fromEntity(MyUserEntity.fromDocument(doc['myUser'])),
      postImage: doc['postImage'] as String?,
      likes: (doc['likes'] ?? 0) as int,
      likedBy: List<String>.from(doc['likedBy'] ?? []),
      commentCount: (doc['commentCount'] ?? 0) as int
    );
  }

  @override
  List<Object?> get props =>
      [postId, post, createdAt, myUser, postImage, likes, likedBy, commentCount];

  @override
  String toString() {
    return '''PostEntity: {
      postId: $postId
      post: $post
      createdAt: $createdAt
      myUser: $myUser
      postImage : $postImage
      likes: $likes
      likedBy: $likedBy
      commentCount: $commentCount
    }''';
  }
}
