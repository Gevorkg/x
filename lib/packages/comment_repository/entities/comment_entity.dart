import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../user_repository/models/user_model.dart';
import '../../user_repository/entities/user_entity.dart';

class CommentEntity extends Equatable {
  String commentId;
  String postId; // Связь с постом
  String comment;
  DateTime createdAt;
  MyUser myUser;
  String? commentImage;
  int likes;
  List<String> likedBy;
  int commentCount;

  CommentEntity({
    required this.commentId,
    required this.postId,
    required this.comment,
    required this.createdAt,
    required this.myUser,
    this.commentImage,
    required this.likes,
    required this.likedBy,
    required this.commentCount,
  });

  @override
  List<Object?> get props => [
        commentId,
        postId,
        comment,
        createdAt,
        myUser,
        commentImage,
        likes,
        likedBy,
        commentCount
      ];

  Map<String, Object?> toDocument() {
    return {
      'commentId': commentId,
      'postId': postId,
      'comment': comment,
      'createdAt': createdAt,
      'myUser': myUser.toEntity().toDocument(),
      'commentImage': commentImage,
      'likes': likes,
      'likedBy': likedBy,
      'commentCount': commentCount,
    };
  }

  static CommentEntity fromDocument(Map<String, dynamic> doc) {
    return CommentEntity(
      commentId: doc['commentId'] as String,
      postId: doc['postId'] as String,
      comment: doc['comment'] as String,
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      myUser: MyUser.fromEntity(MyUserEntity.fromDocument(doc['myUser'])),
      commentImage: doc['commentImage'] as String?,
      likes: (doc['likes'] ?? 0) as int,
      likedBy: List<String>.from(doc['likedBy'] ?? []),
      commentCount: (doc['commentCount'] ?? 0) as int,
    );
  }
}
