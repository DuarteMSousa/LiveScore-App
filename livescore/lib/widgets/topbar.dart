import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Topbar extends StatelessWidget implements PreferredSizeWidget{
  const Topbar({super.key});
  @override
  Widget build(BuildContext context) {
    return 
    Padding(padding: EdgeInsets.symmetric(horizontal: 10),child:Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("LIVESCORE",style: TextStyle(fontSize: 25,letterSpacing: 2),),
        IconButton(onPressed:() {}, icon: Icon(CupertinoIcons.search,size: 30))
      ],
    ) ,);
    
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}