import 'package:flutter/material.dart';

class TileWidget extends StatelessWidget {
  final int value;

  const TileWidget({Key? key, required this.value}) : super(key: key);

  Color getTileColor(int value) {
    switch (value) {
      case 0:
        return const Color(0xFF7945FF);
      case 2:
        return const Color(0xFFFF6B6B); //
      case 4:
        return const Color(0xFFF2C94C); //
      case 8:
        return const Color(0xFF66FD7F); //
      case 16:
        return const Color(0xFFFF95B8); //
      case 32:
        return const Color(0xFF7FD8FF); //
      case 64:
        return const Color(0xFF28A9E0); //
      case 128:
        return const Color(0xFF9575CD); //
      case 256:
        return const Color(0xFFFFA726); // #FFB74D
      case 512:
        return const Color(0xFF00C9B1); // #E57373
      case 1024:
        return const Color(0xFFB5EAAA); // #9575CD
      case 2048:
        return const Color(0xFFC864A9); // #F06292
      default:
        double hue = ((value - 2048) * 10.0) % 360.0;
        return HSVColor.fromAHSV(1.0, hue, 0.5, 0.8).toColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color tileColor = getTileColor(value);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 1000,
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.black, width: 4.0),
      ),
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: value != 0 ? 1.0 : 0.0,
          child: Text(
            value != 0 ? value.toString() : '',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
