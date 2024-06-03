import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TopBarWidget extends StatelessWidget {
  final int score;
  final int best;

  const TopBarWidget({super.key, required this.score, required this.best});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              'SCORE:',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Container(
              width: 100,
              height: 46, // Установите желаемую высоту
              decoration: BoxDecoration(
                color: Color(0xFF5D2DD1),
                borderRadius:
                    BorderRadius.circular(15), // Укажите радиус скругления
              ),
              alignment: Alignment.center, // Центрирование содержимого
              child: Text(
                '$score',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        const SizedBox(width: 46),
        SvgPicture.asset(
          'assets/logo.svg', // Путь к файлу SVG в папке assets
          width: 70, // Укажите ширину
          height: 70, // Укажите высоту
        ),
        const SizedBox(width: 46), // Добавьте промежуток
        Column(
          children: [
            Text(
              'BEST:',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Container(
              width: 100,
              height: 46, // Установите желаемую высоту
              decoration: BoxDecoration(
                color: Color(0xFF5D2DD1),
                borderRadius:
                    BorderRadius.circular(15), // Укажите радиус скругления
              ),
              alignment: Alignment.center, // Центрирование содержимого
              child: Text(
                '$best',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
