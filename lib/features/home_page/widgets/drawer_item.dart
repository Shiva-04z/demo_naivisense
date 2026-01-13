import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTap;
  final String subTitle;

  const DrawerItem({
    super.key,
    required this.iconData,
    required this.title,
    required this.onTap,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 24, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusGeometry.circular(16),
          boxShadow: [BoxShadow(
            color: Colors.black38,blurRadius: 5,spreadRadius: 4,offset:  Offset(0, 7)
          )],
          color: Colors.teal,
        ),
        child: ListTile(
          leading: Icon(iconData, size: 32, color: Colors.white),
          subtitle: Text(subTitle,style: TextStyle(color: Colors.white70),),
          onTap: onTap,
          title: Text(title,style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
