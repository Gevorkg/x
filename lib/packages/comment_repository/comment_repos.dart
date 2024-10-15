import '../user_repository/models/user_model.dart';
import 'models/comment_model.dart';

abstract class CommentRepos {
  Future<Comment> createComment(Comment comment, {String? imageFile});

  Future<String?> uploadCommentImage(String filePath);

 Stream<List<Comment>> getCommentsStream(String postId);

 Future<void> likeComment(String commentId, MyUser user);

  Future<void> deleteComment(String commentId, String userId);
}
