import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_x/packages/comment_repository/entities/comment_entity.dart';
import 'package:flutter_x/packages/comment_repository/models/comment_model.dart';
import 'package:flutter_x/packages/comment_repository/comment_repos.dart';
import 'package:uuid/uuid.dart';

class CommentFirebaseRepos implements CommentRepos {
  final commentCollection = FirebaseFirestore.instance.collection('comments');

  @override
  Future<Comment> createComment(Comment comment, {String? imageFile}) async {
    try {
      comment.commentId = Uuid().v1();
      comment.createdAt = DateTime.now();
      if (imageFile != null) {
        comment.commentImage = await uploadCommentImage(imageFile);
      }
      await commentCollection
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
    // log('Fetching comments for postId: $postId');

    try {
      return commentCollection
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        // log('Received snapshot for postId: $postId, doc count: ${snapshot.docs.length}');

        return snapshot.docs.map((doc) {
          // log('Processing document: ${doc.id}');
          // log('Document data: ${doc.data()}');
          return Comment.fromEntity(CommentEntity.fromDocument(doc.data()));
          
        }).toList();
      });
    } catch (e) {
      // log('Error in getCommentsStream: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> deleteComment(String commentId, String userId) async {
    try {
      // Получаем комментарий по его ID
      final commentDoc = await commentCollection.doc(commentId).get();
      if (commentDoc.exists) {
        final commentData = commentDoc.data()!;
        // Проверяем, что автор комментария — это текущий пользователь
        if (commentData['myUser']['id'] == userId) {
          await commentCollection.doc(commentId).delete();

          // Обновляем счетчик комментариев в посте
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
}
