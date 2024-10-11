import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_x/packages/user_repository/models/user_model.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<List<MyUser>> getAllUsers();

  Future<void> signIn(String email, String password);

  Future<void> logOut();

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> ressetPassword(String email);

  Future<void> setUserData(MyUser myUser);

  Future<MyUser> getMyUser(String myUserId);

  Future<String> uploadAvatarPicture(String file, String userId);

  Future<String> uploadBackgroundPicture(String file, String userId);

  Future<void> toggleSubscription(String currentUserId, String targetUserId);

  Future<List<MyUser>> getFollowers(String userId);

  Future<List<MyUser>> getFollowing(String userId);
}
