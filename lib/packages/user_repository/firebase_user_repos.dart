// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_x/packages/user_repository/entities/user_entity.dart';
import 'package:flutter_x/packages/user_repository/models/user_model.dart';
import 'package:flutter_x/packages/user_repository/user_repos.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final postCollection = FirebaseFirestore.instance.collection('posts');

  FirebaseUserRepository({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }

  @override
  Future<List<MyUser>> getAllUsers() async {
    try {
      final snapshot = await usersCollection.get();
      return snapshot.docs.map((doc) {
        return MyUser.fromEntity(MyUserEntity.fromDocument(doc.data()));
      }).toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: myUser.email, password: password);
      myUser = myUser.copyWith(id: user.user!.uid);

      return myUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Error during sign up: ${e.message}');
      }
      rethrow;
    } catch (e) {
      print('Unexpected error during sign up: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('Error during sign in: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error during sign out: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> ressetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error during password reset: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser user) async {
    try {
      await usersCollection.doc(user.id).set(user.toEntity().toDocument());
    } catch (e) {
      log(e.toString() as num);
      rethrow;
    }
  }

  @override
  Future<MyUser> getMyUser(String myUserId) async {
    try {
      return usersCollection.doc(myUserId).get().then((value) =>
          MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserInfo(String userId,
      {String? name, String? bio}) async {
    try {
      Map<String, dynamic> dataToUpdate = {};

      if (name != null) {
        dataToUpdate['name'] = name;
      }
      if (bio != null) {
        dataToUpdate['bio'] = bio;
      }

      if (dataToUpdate.isNotEmpty) {
        await usersCollection.doc(userId).update(dataToUpdate);
      }
    } catch (e) {
      print('Error updating user info: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<String> uploadAvatarPicture(String file, String userId) async {
    try {
      File imageFile = File(file);
      Reference firebaseStoreRef =
          FirebaseStorage.instance.ref().child('$userId/PP/${userId}_lead');
      await firebaseStoreRef.putFile(imageFile);
      String url = await firebaseStoreRef.getDownloadURL();
      await usersCollection.doc(userId).update({'picture': url});
      return url;
    } catch (e) {
      log(e.toString() as num);
      rethrow;
    }
  }

  @override
  Future<String> uploadBackgroundPicture(String file, String userId) async {
    try {
      File imageFile = File(file);
      Reference firebaseStoreRef =
          FirebaseStorage.instance.ref().child('$userId/BP/${userId}_lead');
      await firebaseStoreRef.putFile(imageFile);
      String url = await firebaseStoreRef.getDownloadURL();
      await usersCollection.doc(userId).update({'backgroundPicture': url});
      return url;
    } catch (e) {
      log(e.toString() as num);
      rethrow;
    }
  }

  @override
  Future<void> followUser(String currentUserId, String targetUserId) async {
    try {
      await usersCollection.doc(targetUserId).update({
        'followers': FieldValue.arrayUnion([currentUserId]),
      });

      await usersCollection.doc(currentUserId).update({
        'following': FieldValue.arrayUnion([targetUserId]),
      });

      QuerySnapshot postSnapshots = await postCollection
          .where('myUser.id', isEqualTo: targetUserId)
          .get();
      for (var doc in postSnapshots.docs) {
        await doc.reference.update({
          'myUser.followers': FieldValue.arrayUnion([currentUserId]),
        });
      }
    } catch (e) {
      print('Error following user: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    try {
      await usersCollection.doc(targetUserId).update({
        'followers': FieldValue.arrayRemove([currentUserId]),
      });

      await usersCollection.doc(currentUserId).update({
        'following': FieldValue.arrayRemove([targetUserId]),
      });

      QuerySnapshot postSnapshots = await postCollection
          .where('myUser.id', isEqualTo: targetUserId)
          .get();
      for (var doc in postSnapshots.docs) {
        await doc.reference.update({
          'myUser.followers': FieldValue.arrayRemove([currentUserId]),
        });
      }
    } catch (e) {
      print('Error unfollowing user: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    DocumentSnapshot currentUserSnapshot =
        await usersCollection.doc(currentUserId).get();
    List<String> following =
        List<String>.from(currentUserSnapshot['following'] ?? []);
    return following.contains(targetUserId);
  }

  @override
  Future<List<MyUser>> getFollowers(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();

      List<String> followerIds =
          List<String>.from(userSnapshot['followers'] ?? []);

      List<MyUser> followers = [];
      for (String followerId in followerIds) {
        DocumentSnapshot followerSnapshot =
            await usersCollection.doc(followerId).get();

        if (followerSnapshot.data() is Map<String, dynamic>) {
          followers.add(MyUser.fromEntity(MyUserEntity.fromDocument(
              followerSnapshot.data() as Map<String, dynamic>)));
        } else {
          print('Data for follower $followerId is not a Map<String, dynamic>');
        }
      }

      return followers;
    } catch (e) {
      print('Error getting followers: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<MyUser>> getFollowing(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();

      List<String> followingIds =
          List<String>.from(userSnapshot['following'] ?? []);

      List<MyUser> following = [];
      for (String followingId in followingIds) {
        DocumentSnapshot followingSnapshot =
            await usersCollection.doc(followingId).get();

        if (followingSnapshot.data() is Map<String, dynamic>) {
          following.add(MyUser.fromEntity(MyUserEntity.fromDocument(
              followingSnapshot.data() as Map<String, dynamic>)));
        } else {
          print(
              'Data for following $followingId is not a Map<String, dynamic>');
        }
      }

      return following;
    } catch (e) {
      print('Error getting following: ${e.toString()}');
      rethrow;
    }
  }
}
