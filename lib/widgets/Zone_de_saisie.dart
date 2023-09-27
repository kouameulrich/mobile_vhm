import 'package:flutter/material.dart';
import 'package:mobile_whm_2/widgets/default.colors.dart';

Widget ZoneSaisie(BuildContext context, TextEditingController controller) {
  return SizedBox(
    height: 55,
    child: TextFormField(
      controller: controller,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: "Remplissez le champ",
        filled: true,
        fillColor: Defaults.white,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(width: 1, color: Defaults.white), //<-- SEE HERE
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Defaults.white),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Remplissez le champ s'il vous plait";
        }
        return null;
      },
    ),
  );
}
