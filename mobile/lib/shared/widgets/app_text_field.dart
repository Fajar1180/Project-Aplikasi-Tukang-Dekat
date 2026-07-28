import 'package:flutter/material.dart';

<<<<<<< HEAD
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
=======
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    required this.label,
    this.initialValue,
>>>>>>> repo-b/main
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
<<<<<<< HEAD
    this.prefixIcon,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
=======
    this.errorText,
    this.prefixIcon,
    this.maxLines = 1,
    this.onChanged,
    this.onSaved,
  });

  final TextEditingController? controller;
  final String label;
  final String? initialValue;
>>>>>>> repo-b/main
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
<<<<<<< HEAD
  final Widget? prefixIcon;
  final int maxLines;
  final void Function(String)? onChanged;
=======
  final String? errorText;
  final Widget? prefixIcon;
  final int maxLines;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null && widget.controller == null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != null && 
        oldWidget.initialValue != widget.initialValue && 
        widget.controller == null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
>>>>>>> repo-b/main

  @override
  Widget build(BuildContext context) {
    return TextFormField(
<<<<<<< HEAD
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
=======
      controller: _controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      validator: widget.validator,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        errorText: widget.errorText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
>>>>>>> repo-b/main
      ),
    );
  }
}