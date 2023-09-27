import 'package:flutter/material.dart';
import 'package:mobile_whm_2/models/memberBis.dart';
import 'package:mobile_whm_2/widgets/default.colors.dart';

class MemberItemBis extends StatelessWidget {
  MemberItemBis({Key? key, required this.item, this.onTap}) : super(key: key);

  final MemberBis item;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
      title: Text(
        item.memberFullName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Defaults.bluePrincipal,
        ),
      ),
      subtitle: Text(
        item.memberPhone,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Defaults.bluePrincipal,
        ),
      ),
      trailing: ElevatedButton(
          onPressed: !item.flag ? onTap : null, child: Text('Valider')),
    );
  }
}
