// widgets/loading_indicator.dart
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Color(0xFF4077FF),
      ),
    );
  }
}
