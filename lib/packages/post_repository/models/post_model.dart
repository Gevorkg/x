import 'package:flutter_x/packages/post_repository/entities/post_entity.dart';
import 'package:flutter_x/packages/user_repository/models/user_model.dart';

class Post {
  String postId;
  String post;
  DateTime createdAt;
  MyUser myUser;
  String? postImage;
  int likes;
  List<String> likedBy;
  int commentCount;

  Post({
    required this.postId,
    required this.post,
    required this.createdAt,
    required this.myUser,
    this.postImage,
    required this.likes,
    required this.likedBy,
    required this.commentCount
  });

  static var empty = Post(
      postId: '',
      createdAt: DateTime.now(),
      post: '',
      myUser: MyUser.empty,
      postImage: '',
      likes: 0,
      likedBy: [], 
      commentCount: 0,
      );

  Post copyWith({
    String? postId,
    String? post,
    DateTime? createdAt,
    MyUser? picture,
    String? postImage,
    int? likes,
    List<String>? likedBy,
    int? commentCount,
  }) {
    return Post(
      postId: postId ?? this.postId,
      post: post ?? this.post,
      createdAt: createdAt ?? this.createdAt,
      myUser: myUser,
      postImage: postImage ?? postImage,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  bool get isEmpty => this == Post.empty;
  bool get isNotEmpty => this != Post.empty;

  PostEntity toEntity() {
    return PostEntity(
        postId: postId,
        post: post,
        createdAt: createdAt,
        myUser: myUser,
        postImage: postImage,
        likes: likes,
        likedBy: likedBy,
        commentCount: commentCount
        );
  }

  static Post fromEntity(PostEntity entity) {
    return Post(
      postId: entity.postId,
      post: entity.post,
      createdAt: entity.createdAt,
      myUser: entity.myUser,
      postImage: entity.postImage,
      likes: entity.likes,
      likedBy: entity.likedBy,
      commentCount: entity.commentCount
    );
  }

  @override
  String toString() {
    return '''Post: {
      postId: $postId
      post: $post
      createdAt: $createdAt
      myUser: $myUser
      postImage: $postImage
      likes: $likes
      likedBy: $likedBy
      commentCount: $commentCount
    }''';
  }
}
