import 'package:flutter/material.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/text_widget.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String? hint;
  bool? isObscure;
  final TextEditingController controller;
  final double? width;
  final double? height;
  final int? maxLine;
  final TextInputType? inputType;
  late bool? showEye;
  late bool? enabled;
  late Color? color;
  late Color? borderColor;
  late Color? hintColor;
  late double? radius;
  final String? Function(String?)? validator; // Add validator parameter

  final TextCapitalization? textCapitalization;

  bool? hasValidator;
  Widget? prefix;

  late int? length;

  Widget? suffix;

  TextFieldWidget({
    super.key,
    required this.label,
    this.hint = '',
    required this.controller,
    this.isObscure = false,
    this.width = double.infinity,
    this.height = 65,
    this.maxLine = 1,
    this.prefix,
    this.suffix,
    this.length,
    this.hintColor = Colors.black,
    this.borderColor = Colors.transparent,
    this.showEye = false,
    this.enabled = true,
    this.color = Colors.black,
    this.radius = 100,
    this.hasValidator = true,
    this.textCapitalization = TextCapitalization.sentences,
    this.inputType = TextInputType.text,
    this.validator, // Add validator parameter
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: TextFormField(
          maxLength: widget.length,
          enabled: widget.enabled,
          style: const TextStyle(
            fontFamily: 'Medium',
            fontSize: 24,
          ),
          textCapitalization: widget.textCapitalization!,
          keyboardType: widget.inputType,
          decoration: InputDecoration(
            prefix: widget.prefix,
            suffixIcon: widget.suffix ??
                (widget.showEye! == true
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            widget.isObscure = !widget.isObscure!;
                          });
                        },
                        icon: widget.isObscure!
                            ? const Icon(
                                Icons.visibility,
                                color: secondary,
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: secondary,
                              ))
                    : const SizedBox()),
            hintText: widget.hint,
            border: InputBorder.none,
            label: TextWidget(
              text: widget.label,
              fontSize: 18,
              color: secondary,
            ),
            hintStyle: const TextStyle(
              fontFamily: 'Regular',
              color: Colors.grey,
              fontSize: 24,
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.borderColor!,
              ),
              borderRadius: BorderRadius.circular(widget.radius!),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.borderColor!,
              ),
              borderRadius: BorderRadius.circular(widget.radius!),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.borderColor!,
              ),
              borderRadius: BorderRadius.circular(widget.radius!),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(widget.radius!),
            ),
            errorStyle: const TextStyle(fontFamily: 'Medium', fontSize: 12),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(widget.radius!),
            ),
          ),

          maxLines: widget.maxLine,
          obscureText: widget.isObscure!,
          controller: widget.controller,
          validator: widget.hasValidator!
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a ${widget.label}';
                  }

                  return null;
                }
              : widget.validator, // Pass the validator to the TextFormField
        ),
      ),
    );
  }
}
