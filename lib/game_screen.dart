import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_logic_bloc.dart';
import 'top_bar_widget.dart';
import 'game_grid_widget.dart';
import 'new_game_button.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameLogic = context.read<GameLogicCubit>();

    return Scaffold(
      body: Container(
        color: const Color(0xFF7945FF),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlocBuilder<GameLogicCubit, GameLogicState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      TopBarWidget(
                          score: state.score, best: gameLogic.getBestScore()),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Stack(
                        children: [
                          //const NewGrid(),
                          GameGridWidget(),
                          if (!gameLogic.hasAvailableMoves())
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                child: const Center(
                                  child: Text(
                                    'Game Over',
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      const NewGameButton(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
