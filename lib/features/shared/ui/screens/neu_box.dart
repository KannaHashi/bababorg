import 'package:flutter/material.dart';

class NeuBox extends StatelessWidget {
  final child;
  const NeuBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(child: child),
      decoration: BoxDecoration(
        // color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // darker shadow on the bottom right
          BoxShadow(
            color: Colors.black,
            blurRadius: 15,
            offset: const Offset(5, 5),
          ),

          // lighter shadow on the top left
          BoxShadow(
            color: Colors.grey.shade800,
            blurRadius: 15,
            offset: Offset(-5, -5),
          ),
        ],
      ),
    );
  }
}

class NeuBoxDark extends StatelessWidget {
  final child;
  const NeuBoxDark({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(child: child),
      decoration: BoxDecoration(
        // color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class NeuBoxDark2 extends StatelessWidget {
  final child;
  const NeuBoxDark2({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(child: child),
      decoration: BoxDecoration(
        // color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}