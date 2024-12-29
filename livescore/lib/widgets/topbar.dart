import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Topbar extends StatelessWidget implements PreferredSizeWidget {
  const Topbar({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        "LIVESCORE",
        style: TextStyle(fontSize: 25, letterSpacing: 2),
      ),
      actions: [
        IconButton(
            onPressed: () {context.push("/search");}, icon: Icon(CupertinoIcons.search),iconSize: 30)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
