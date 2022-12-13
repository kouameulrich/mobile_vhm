import 'package:flutter/material.dart';

import '../models/member.dart';
import '../models/memberBis.dart';

class MemberItemBis extends StatelessWidget {
  MemberItemBis({Key? key, required this.item, this.onTap}) : super(key: key);

  final MemberBis item;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 50.0,
        backgroundImage: AssetImage('images/avatar_image.jpg'),
      ),
      title: Text(item.memberFullName),
      subtitle: Text(item.memberPhone),
      trailing: ElevatedButton(
        child: Text('Valider'),
        onPressed: !item.flag ? onTap : null,
      ),
    );
  }
}
