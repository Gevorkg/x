import 'package:flutter_x/packages/post_repository/models/post_model.dart';
import 'package:flutter_x/packages/user_repository/models/user_model.dart';

abstract class PostRepository {
  Future<Post> createPost(Post post, {String? imageFile});

  Stream<List<Post>> getPost();
  
  Future<List<Post>> getPostByUserId(String userId);

  Future<String?> uploadPostImage(String filePath);

  Future<void> likePost(String postId, MyUser user);

  Stream<List<Post>> getPostByFollowing(String currentUserId);
}
