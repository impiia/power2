import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'tile_widget.dart';
import 'game_logic_bloc.dart';

class GameGridWidget extends StatelessWidget {
  double _verticalDragStartY = 0;
  double _horizontalDragStartX = 0;

  GameGridWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameLogic = context.read<GameLogicCubit>();

    void handleVerticalDragEnd(double dyDiff) {
      if (dyDiff > 5) {
        gameLogic.moveDown();
      } else if (dyDiff < -5) {
        gameLogic.moveUp();
      }
    }

    void handleHorizontalDragEnd(double dxDiff) {
      if (dxDiff > 5) {
        gameLogic.moveRight();
      } else if (dxDiff < -5) {
        gameLogic.moveLeft();
      }
    }

    return BlocBuilder<GameLogicCubit, GameLogicState>(
      builder: (context, state) {
        return Container(
          width: (MediaQuery.of(context).size.width /
                      MediaQuery.of(context).size.height >
                  0.6) // условие для примерно квадратных экранов
              ? MediaQuery.of(context).size.width *
                  0.9 // ширина для примерно квадратных экранов
              : MediaQuery.of(context).size.width, // ширина для других экранов
          height: (MediaQuery.of(context).size.width /
                      MediaQuery.of(context).size.height >
                  0.6) // условие для примерно квадратных экранов
              ? MediaQuery.of(context).size.width *
                  0.9 // ширина для примерно квадратных экранов
              : MediaQuery.of(context).size.width, // высота для других экранов

          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.black, width: 4.0),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              GestureDetector(
                onVerticalDragStart: (details) {
                  _verticalDragStartY = details.localPosition.dy;
                },
                onVerticalDragEnd: (details) {
                  double dyDiff = details.primaryVelocity ?? 0;
                  handleVerticalDragEnd(dyDiff);
                },
                onHorizontalDragStart: (details) {
                  _horizontalDragStartX = details.localPosition.dx;
                },
                onHorizontalDragEnd: (details) {
                  double dxDiff = details.primaryVelocity ?? 0;
                  handleHorizontalDragEnd(dxDiff);
                },
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gameLogic.size,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: gameLogic.size * gameLogic.size,
                  itemBuilder: (context, index) {
                    int value = state.board[index ~/ gameLogic.size]
                        [index % gameLogic.size];
                    return TileWidget(value: value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
