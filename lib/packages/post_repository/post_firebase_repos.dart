import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_x/packages/post_repository/entities/post_entity.dart';
import 'package:flutter_x/packages/post_repository/models/post_model.dart';
import 'package:flutter_x/packages/user_repository/models/user_model.dart';
import 'package:flutter_x/packages/post_repository/post_repos.dart';
import 'package:uuid/uuid.dart';

class PostFirebaseRepository implements PostRepository {
  final postCollection = FirebaseFirestore.instance.collection('posts');
  final usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Future<Post> createPost(Post post, {String? imageFile}) async {
    try {
      post.postId = Uuid().v1();
      post.createdAt = DateTime.now();
      if (imageFile != null) {
        post.postImage = await uploadPostImage(imageFile);
      }
      await postCollection.doc(post.postId).set(post.toEntity().toDocument());
      return post;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Stream<List<Post>> getPost() {
    try {
      return postCollection
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {

        return snapshot.docs.map((doc) {
          return Post.fromEntity(PostEntity.fromDocument(doc.data()));
        }).toList();
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<Post>> getPostByFollowing(String currentUserId) async* {
    try {
      
      DocumentSnapshot currentUserSnapshot =
          await usersCollection.doc(currentUserId).get();
      List<String> following =
          List<String>.from(currentUserSnapshot['following'] ?? []);

      
      if (following.isEmpty) {
        yield [];
        return;
      }

      
      yield* postCollection
          .where('myUser.id',
              whereIn:
                  following) 
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {

        return snapshot.docs.map((doc) {
          return Post.fromEntity(PostEntity.fromDocument(doc.data()));
        }).toList();
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Post>> getPostByUserId(String userId) async {
    try {
      final querySnapshot = await postCollection
          .where('myUser.id', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((e) => Post.fromEntity(PostEntity.fromDocument(e.data())))
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String?> uploadPostImage(String filePath) async {
    try {
      File imageFile = File(filePath);
      String uniqueFilePath = 'posts/${Uuid().v1()}.jpg';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref(uniqueFilePath).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<void> likePost(String postId, MyUser user) async {
    try {
      final postDoc = postCollection.doc(postId);
      final postSnapshot = await postDoc.get();

      if (postSnapshot.exists) {
        final postData = postSnapshot.data()!;
        List<String> likedBy = List<String>.from(postData['likedBy'] ?? []);

        
        if (likedBy.contains(user.nickname)) {
          
          likedBy.remove(user.nickname);
          await postDoc.update({
            'likes': FieldValue.increment(-1),
            'likedBy': likedBy,
          });
        } else {
          
          likedBy.add(user.nickname);
          await postDoc.update({
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
