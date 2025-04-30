import 'package:flutter/material.dart';

class LinkTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const LinkTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        overlayColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
