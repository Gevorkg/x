import 'models/comment_model.dart';

abstract class CommentRepos {
  Future<Comment> createComment(Comment comment, {String? imageFile});

  Future<String?> uploadCommentImage(String filePath);

 Stream<List<Comment>> getCommentsStream(String postId);

  Future<void> deleteComment(String commentId, String userId);
}
