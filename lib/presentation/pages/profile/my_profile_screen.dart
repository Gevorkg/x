import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/packages/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:flutter_x/packages/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:flutter_x/presentation/pages/profile/profile_followers.dart';
import 'package:flutter_x/presentation/pages/profile/profile_following.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../packages/blocs/auth_bloc/auth_bloc.dart';
import '../../../packages/blocs/follow_bloc/follow_bloc.dart';
import '../../../packages/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import '../../../packages/post_repository/post_firebase_repos.dart';
import '../../../packages/user_repository/firebase_user_repos.dart';
import '../../../packages/user_repository/models/user_model.dart';
import '../../components/TextStyle.dart';
import '../../widgets/Image_picker_widget.dart';
import 'profile_posts.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({
    super.key,
  });

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with TickerProviderStateMixin {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    _nameController = TextEditingController();
    _bioController = TextEditingController();
  }

  void _toggleEditing(MyUser user) {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _nameController.text = user.name;
        _bioController.text = user.bio ?? '';
      }
    });
  }

  void _saveProfile() {
    context.read<UpdateUserInfoBloc>().add(
          UpdateUserInfo(
            userId: context.read<AuthBloc>().state.user!.uid,
            name: _nameController.text,
            bio: _bioController.text,
          ),
        );
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyUserBloc, MyUserState>(
      builder: (context, state) {
        if (state.status == MyUserStatus.success) {
          final myUser = state.user!;
          return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
            listener: (context, state) {
              if (state is UploadPPSuccess) {
                setState(() {
                  context.read<MyUserBloc>().state.user!.picture =
                      state.userImage;
                });
              }
              if (state is UploadBackgroundPictureSuccess) {
                setState(() {
                  context.read<MyUserBloc>().state.user!.backgroundPicture =
                      state.userBackgroundImage;
                });
              }
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                title: const MyTxtStlArtic(text: 'Profile'),
                backgroundColor: Colors.white,
              ),
              body: Column(
                children: [
                  Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ImagePickerWidget(
                            onImageSelected: (path) {
                              context.read<UpdateUserInfoBloc>().add(
                                    UploadBackgroundPicture(path, myUser.id),
                                  );
                            },
                            imageUrl: myUser.backgroundPicture,
                            height: 150,
                            buttonText: 'Select Background Picture',
                          ),
                          Positioned(
                            top: 100,
                            left: 16,
                            child: ClipOval(
                              child: CircleAvatarPickerWidget(
                                onImageSelected: (path) {
                                  context.read<UpdateUserInfoBloc>().add(
                                        UploadPicture(path, myUser.id),
                                      );
                                },
                                imageUrl: myUser.picture,
                                buttonText: '', 
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, left: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _isEditing
                                      ? TextField(
                                          controller: _nameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Name',
                                          ),
                                        )
                                      : MyTxtStlName(text: myUser.name),
                                      const SizedBox(height: 5),
                                  MyTxtStlNickname(text: '@${myUser.nickname.toLowerCase()}'),
                                  const SizedBox(height: 5),
                                  _isEditing
                                      ? TextField(
                                          controller: _bioController,
                                          decoration: const InputDecoration(
                                            labelText: 'Bio',
                                          ),
                                        )
                                      : MyTxtStlContent(text: myUser.bio ?? ''),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(_isEditing ? Icons.check : Icons.edit),
                              onPressed: () {
                                if (_isEditing) {
                                  _saveProfile();
                                } else {
                                  _toggleEditing(myUser);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TabBar(
                    controller: tabController,
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.black,
                    labelStyle: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    indicatorColor: Colors.blue,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(
                        child: BlocBuilder<GetPostBloc, GetPostState>(
                          builder: (context, postState) {
                            if (postState is GetPostSuccess) {
                              return Text('${postState.posts.length} posts');
                            } else if (postState is GetPostLoading) {
                              return const CircularProgressIndicator();
                            } else {
                              return const Text('0 posts');
                            }
                          },
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(myUser.followers.isNotEmpty
                                ? myUser.followers.length.toString()
                                : '0'),
                            const SizedBox(width: 5),
                            const Text('followers'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(myUser.following.isNotEmpty
                                ? myUser.following.length.toString()
                                : '0'),
                            const SizedBox(width: 5),
                            const Text('following'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(controller: tabController, children: [
                      BlocProvider(
                        create: (context) => GetPostBloc(
                            postRepository: PostFirebaseRepository())
                          ..add(GetPostsByUserId(myUser.id)),
                        child: const ProfilePosts(),
                      ),
                      MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => MyUserBloc(
                              myUserRepository:
                                  context.read<AuthBloc>().userRepository,
                            )..add(GetMyUser(
                                myUserId:
                                    context.read<AuthBloc>().state.user!.uid)),
                          ),
                          BlocProvider(
                            create: (context) => FollowBloc(
                              userRepository: FirebaseUserRepository(),
                            )..add(GetFollowers(userId: myUser.id)),
                            child: const ProfileFollowers(),
                          ),
                        ],
                        child: const ProfileFollowers(),
                      ),
                      MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => MyUserBloc(
                              myUserRepository:
                                  context.read<AuthBloc>().userRepository,
                            )..add(GetMyUser(
                                myUserId:
                                    context.read<AuthBloc>().state.user!.uid)),
                          ),
                          BlocProvider(
                            create: (context) => FollowBloc(
                              userRepository: FirebaseUserRepository(),
                            )..add(GetFollowing(userId: myUser.id)),
                          )
                        ],
                        child: const ProfileFollowing(),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          );
        } else if (state.status == MyUserStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text('Error loading user data'));
        }
      },
    );
  }
}
