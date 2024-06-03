import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_logic_bloc.dart';

class NewGameButton extends StatelessWidget {
  const NewGameButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        BlocProvider.of<GameLogicCubit>(context).startNewGame();
      },
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFFD6687), // Background color
        padding: const EdgeInsets.fromLTRB(30, 13, 30, 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(width: 4, color: Colors.black),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.refresh,
            color: Colors.black,
            size: 40, // Размер иконки
          ),
          SizedBox(width: 10),
          Text(
            'New Game',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}
