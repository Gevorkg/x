import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_x/packages/comment_repository/entities/comment_entity.dart';
import 'package:flutter_x/packages/comment_repository/models/comment_model.dart';
import 'package:flutter_x/packages/comment_repository/comment_repos.dart';
import 'package:uuid/uuid.dart';

import '../user_repository/models/user_model.dart';

class CommentFirebaseRepos implements CommentRepos {
  final _commentCollection = FirebaseFirestore.instance.collection('comments');

  @override
  Future<Comment> createComment(Comment comment, {String? imageFile}) async {
    try {
      comment.commentId = Uuid().v1();
      comment.createdAt = DateTime.now();
      if (imageFile != null) {
        comment.commentImage = await uploadCommentImage(imageFile);
      }
      await _commentCollection
          .doc(comment.commentId)
          .set(comment.toEntity().toDocument());

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(comment.postId)
          .update({'commentCount': FieldValue.increment(1)});
      return comment;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String?> uploadCommentImage(String filePath) async {
    try {
      File imageFile = File(filePath);
      String uniqueFilePath = 'comments/${Uuid().v1()}.jpg';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref(uniqueFilePath).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Stream<List<Comment>> getCommentsStream(String postId) {
    try {
      return _commentCollection
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Comment.fromEntity(CommentEntity.fromDocument(doc.data()));
        }).toList();
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteComment(String commentId, String userId) async {
    try {
      final commentDoc = await _commentCollection.doc(commentId).get();
      if (commentDoc.exists) {
        final commentData = commentDoc.data()!;

        if (commentData['myUser']['id'] == userId) {
          await _commentCollection.doc(commentId).delete();

          await FirebaseFirestore.instance
              .collection('posts')
              .doc(commentData['postId'])
              .update({'commentCount': FieldValue.increment(-1)});
        } else {
          throw Exception("User is not authorized to delete this comment");
        }
      } else {
        throw Exception("Comment does not exist");
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> likeComment(String commentId, MyUser user) async {
    try {
      final commentDoc = _commentCollection.doc(commentId);
      final commentSnapshot = await commentDoc.get();

      if (commentSnapshot.exists) {
        final commentData = commentSnapshot.data()!;
        List<String> likedBy = List<String>.from(commentData['likedBy'] ?? []);

        if (likedBy.contains(user.nickname)) {
          likedBy.remove(user.nickname);
          await commentDoc.update({
            'likes': FieldValue.increment(-1),
            'likedBy': likedBy,
          });
        } else {
          likedBy.add(user.nickname);
          await commentDoc.update({
            'likes': FieldValue.increment(1),
            'likedBy': likedBy,
          });
        }
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
