import 'package:flutter_x/packages/comment_repository/entities/comment_entity.dart';
import 'package:flutter_x/packages/user_repository/models/user_model.dart';

class Comment {
  String commentId;
  String postId; 
  String comment;
  DateTime createdAt;
  MyUser myUser;
  String? commentImage;
  int likes;
  List<String> likedBy;
  int commentCount;

  Comment(
      {required this.commentId,
      required this.postId,
      required this.comment,
      required this.createdAt,
      required this.myUser,
      this.commentImage,
      required this.likes,
      required this.likedBy,
      required this.commentCount});

  
  static var empty = Comment(
      commentId: '',
      postId: '',
      createdAt: DateTime.now(),
      comment: '',
      myUser: MyUser.empty,
      commentImage: '',
      likes: 0,
      likedBy: [],
      commentCount: 0);

  CommentEntity toEntity() {
    return CommentEntity(
      commentId: commentId,
      postId: postId,
      comment: comment,
      createdAt: createdAt,
      myUser: myUser,
      commentImage: commentImage,
      likes: likes,
      likedBy: likedBy,
      commentCount: commentCount,
    );
  }

  static Comment fromEntity(CommentEntity entity) {
    return Comment(
      commentId: entity.commentId,
      postId: entity.postId,
      comment: entity.comment,
      createdAt: entity.createdAt,
      myUser: entity.myUser,
      commentImage: entity.commentImage,
      likes: entity.likes,
      likedBy: entity.likedBy,
      commentCount: entity.commentCount,
    );
  }

  @override
  String toString() {
    return '''Comment: {
    commentId: $commentId
      postId: $postId
      comment: $comment
      createdAt: $createdAt
      myUser: $myUser
      commentImage: $commentImage
      likes: $likes
      likedBy: $likedBy
      commentCount : $commentCount,

    }''';
  }
}
