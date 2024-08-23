import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
  final String title;
  final bool loading;
  final VoidCallback onTap;
  const RoundButton({
    super.key,
    required this.title,
    this.loading = false,
    required this.onTap,
  });

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(12)),
          child: widget.loading == true
              ? const Center(child:  CircularProgressIndicator.adaptive(strokeWidth: 2,backgroundColor: Colors.white,))
              : Center(child: Text(widget.title,style: const TextStyle(color: Colors.white),))),
    );
  }
}
