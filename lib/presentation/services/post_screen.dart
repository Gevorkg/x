import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/packages/post_repository/models/post_model.dart';
import 'package:flutter_x/packages/user_repository/models/user_model.dart';
import 'package:flutter_x/packages/blocs/create_post_bloc/create_post_bloc.dart';
import 'package:flutter_x/presentation/components/TextField.dart';
import 'package:image_picker/image_picker.dart';

class PostScreen extends StatefulWidget {
  final MyUser myUser;
  const PostScreen(this.myUser, {super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Post post;
  TextEditingController _postController = TextEditingController();
  String? imagePath;

  @override
  void initState() {
    post = Post.empty;
    post.myUser = widget.myUser;
    super.initState();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        imagePath = image.path; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostSucess) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_postController.text.isNotEmpty) {
              setState(() {
                post.post = _postController.text;
              });
              context.read<CreatePostBloc>().add(CreatePost(post, imageFile: imagePath));
            } else {
              log(post.toString());
            }
          },
          child: Icon(Icons.publish),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text('Create Post'),
          actions: [
            IconButton(
              icon: Icon(Icons.photo),
              onPressed: _pickImage, 
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                SearchField(
                  controller: _postController,
                  hintText: 'Type...',
                ),
                if (imagePath != null) 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.file(File(imagePath!), ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
