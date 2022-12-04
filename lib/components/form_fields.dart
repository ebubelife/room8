import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? type;
  final bool? obscureText;
  final Color? focus;
  final FocusNode? node;
  final IconButton? suffixIcon;
  final int? maxL;

  const CustomField(
      {Key? key,
      this.hint,
      this.label,
      this.controller,
      this.type,
      this.node,
      this.suffixIcon,
      this.obscureText,
      this.maxL,
      this.focus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 13),
          child: Text(label ?? "", style: TextStyle(color: Colors.black)),
        ),
        const SizedBox(height: 2),
        TextField(
          controller: controller,
          cursorColor: Color.fromARGB(255, 245, 57, 0),
          obscureText: obscureText ?? false,
          keyboardType: type ?? TextInputType.text,
          maxLength: maxL,
          
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 12,
              height: 1.5,
              // color: white.withOpacity(.7),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 109, 10, 3).withOpacity(0.3),
                  width: 1),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
