import 'package:flutter/material.dart';

import '../models/member.dart';

class MemberItem extends StatelessWidget {
  MemberItem({Key? key, required this.item, this.onTap}) : super(key: key);

  final Member item;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 50.0,
        backgroundImage: AssetImage('images/avatar_image.jpg'),
      ),
      title: Text(item.fullName),
      subtitle: Text(item.tel),
      trailing: ElevatedButton(
        child: Text('Valider'),
        onPressed: !item.presence ? onTap : null,
      ),
    );
  }
}
