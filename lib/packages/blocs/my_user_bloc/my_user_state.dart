part of 'my_user_bloc.dart';

enum MyUserStatus { success, loading, failure }

class MyUserState extends Equatable {
  final MyUserStatus status;
  final MyUser? user;

  MyUserState._({this.status = MyUserStatus.loading, this.user});

  MyUserState.loading() : this._();

  MyUserState.success(MyUser user)
      : this._(status: MyUserStatus.success, user: user);

  MyUserState.failure() : this._(status: MyUserStatus.failure);

  @override
  
  List<Object?> get props => [status, user];
}
