 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../packages/user_repository/models/user_model.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final MyUser currentUser;

  const MyAppBar({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            backgroundImage:
                currentUser.picture != null && currentUser.picture!.isNotEmpty
                    ? NetworkImage(currentUser.picture!)
                    : null,
            child: currentUser.picture == null || currentUser.picture!.isEmpty
                ? const Center(child: Icon(Icons.person))
                : null,
          ),
        ),
        title: Text(
          currentUser.name,
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}  