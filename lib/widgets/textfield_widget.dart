import 'package:flutter/material.dart';
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

  TextFieldWidget({
    super.key,
    required this.label,
    this.hint = '',
    required this.controller,
    this.isObscure = false,
    this.width = double.infinity,
    this.height = 65,
    this.maxLine = 1,
    this.hintColor = Colors.black,
    this.borderColor = Colors.transparent,
    this.showEye = false,
    this.enabled = true,
    this.color = Colors.black,
    this.radius = 5,
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
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
              text: widget.label, fontSize: 12, color: widget.hintColor!),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: TextFormField(
              enabled: widget.enabled,
              style: const TextStyle(
                fontFamily: 'QRegular',
                fontSize: 14,
              ),
              textCapitalization: widget.textCapitalization!,
              keyboardType: widget.inputType,
              decoration: InputDecoration(
                suffixIcon: widget.showEye! == true
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            widget.isObscure = !widget.isObscure!;
                          });
                        },
                        icon: widget.isObscure!
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off))
                    : const SizedBox(),
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Enter ${widget.label}',
                border: InputBorder.none,
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor!,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor!,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor!,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                errorStyle: const TextStyle(fontFamily: 'QBold', fontSize: 12),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(5),
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
        ],
      ),
    );
  }
}
