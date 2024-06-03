import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

class GameLogicState {
  final int score;
  List<List<int>> board;
  GameLogicState(this.score, this.board);
}

class GameLogicCubit extends Cubit<GameLogicState> {
  int bestScore = 0;
  final int size = 4;
  bool isNewTileAdded = false;

  GameLogicCubit() : super(GameLogicState(0, [])) {
    state.board = List.generate(size, (_) => List<int>.filled(size, 0));
    startNewGame();
  }

  // Метод для обновления лучшего результата
  void updateBestScore(int score) async {
    if (score > bestScore) {
      bestScore = score;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('bestScore', bestScore);
    }
  }

  // Метод для получения лучшего результата
  int getBestScore() {
    return bestScore;
  }

  bool hasAvailableMoves() {
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (state.board[row][col] == 0) {
          return true;
        }
        if (col < size - 1 &&
            state.board[row][col] == state.board[row][col + 1]) {
          return true;
        }
        if (row < size - 1 &&
            state.board[row][col] == state.board[row + 1][col]) {
          return true;
        }
      }
    }

    return false;
  }

  void startNewGame() {
    SharedPreferences.getInstance().then((prefs) {
      bestScore = prefs.getInt('bestScore') ?? 0;

      int newScore = 0;
      if (state.score > bestScore) {
        updateBestScore(state.score);
      }

      emit(GameLogicState(
          newScore, List.generate(size, (_) => List<int>.filled(size, 0))));
      _generateRandomNumber();
      _generateRandomNumber();
    });
  }

  // void startNewGame() {
  //   SharedPreferences.getInstance().then((prefs) {
  //     bestScore = prefs.getInt('bestScore') ?? 0;
  //
  //     int newScore = 0;
  //     if (state.score > bestScore) {
  //       updateBestScore(state.score);
  //     }
  //
  //     List<List<int>> newBoard =
  //         List.generate(size, (_) => List<int>.filled(size, 0));
  //
  //     // Установите начальные значения
  //     newBoard[size - 1][size - 1] = 2;
  //     newBoard[size - 1][size - 2] = 0;
  //     newBoard[size - 1][size - 3] = 2;
  //     newBoard[size - 1][size - 4] = 0;
  //
  //     emit(GameLogicState(newScore, newBoard));
  //   });
  // }

  void _generateRandomNumber() {
    List<int> emptyCells = [];

    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (state.board[i][j] == 0) {
          emptyCells.add(i * size + j);
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      int randomIndex = emptyCells[Random().nextInt(emptyCells.length)];
      int value = 2; // Значение начинается с 2
      int row = randomIndex ~/ size;
      int col = randomIndex % size;

      state.board[row][col] = value;
      isNewTileAdded = true;
    }
  }

  void moveLeft() {
    int totalScoreToAdd = 0;
    bool moved = false;

    for (int row = 0; row < size; row++) {
      List<int> newRow = [];
      for (int col = 0; col < size; col++) {
        if (state.board[row][col] != 0) {
          newRow.add(state.board[row][col]);
        }
      }

      // Слияние смежных ячеек
      for (int i = 0; i < newRow.length - 1; i++) {
        if (newRow[i] == newRow[i + 1]) {
          newRow[i] *= 2;
          totalScoreToAdd += newRow[i];
          newRow[i + 1] = 0;
        }
      }

      // Перемещаем числа влево
      List<int> finalRow = [];
      for (int value in newRow) {
        if (value != 0) {
          finalRow.add(value);
        }
      }
      finalRow.addAll(List<int>.filled(size - finalRow.length, 0));

      // Проверка, изменились ли позиции плиток
      if (!moved) {
        moved = !ListEquality().equals(state.board[row], finalRow);
      }

      for (int col = 0; col < size; col++) {
        state.board[row][col] = finalRow[col];
      }
    }
    // Генерация новой плитки только если плитки действительно переместились
    if (moved) {
      _generateRandomNumber();
    }

    int newScore = state.score + totalScoreToAdd;
    emit(GameLogicState(newScore, List.from(state.board)));

    if (!hasAvailableMoves()) {
      updateBestScore(newScore);
    }
  }

  void moveRight() {
    int totalScoreToAdd = 0;
    bool moved = false;

    for (int row = 0; row < size; row++) {
      List<int> newRow = [];
      for (int col = 0; col < size; col++) {
        if (state.board[row][col] != 0) {
          newRow.add(state.board[row][col]);
        }
      }

      // Объединение смежных ячеек
      for (int i = newRow.length - 1; i > 0; i--) {
        if (newRow[i] == newRow[i - 1]) {
          newRow[i] *= 2;
          totalScoreToAdd += newRow[i];
          newRow[i - 1] = 0;
        }
      }

      List<int> finalRow = [];
      for (int value in newRow) {
        if (value != 0) {
          finalRow.add(value);
        }
      }
      while (finalRow.length < size) {
        finalRow.insert(0, 0);
      }

      // Проверка, изменились ли позиции плиток
      if (!moved) {
        moved = !ListEquality().equals(state.board[row], finalRow);
      }

      for (int col = 0; col < size; col++) {
        state.board[row][col] = finalRow[col];
      }
    }

    // Генерация новой плитки только если плитки действительно переместились
    if (moved) {
      _generateRandomNumber();
    }

    int newScore = state.score + totalScoreToAdd;
    emit(GameLogicState(newScore, List.from(state.board)));

    if (!hasAvailableMoves()) {
      updateBestScore(newScore);
    }
  }

  void moveUp() {
    int totalScoreToAdd = 0;
    bool moved = false;

    for (int col = 0; col < size; col++) {
      List<int> newColumn = [];
      for (int row = 0; row < size; row++) {
        if (state.board[row][col] != 0) {
          newColumn.add(state.board[row][col]);
        }
      }

      // Объединение смежных ячеек
      for (int i = 0; i < newColumn.length - 1; i++) {
        if (newColumn[i] == newColumn[i + 1]) {
          newColumn[i] *= 2;
          totalScoreToAdd += newColumn[i];
          newColumn[i + 1] = 0;
        }
      }

      List<int> finalColumn = [];
      for (int value in newColumn) {
        if (value != 0) {
          finalColumn.add(value);
        }
      }
      while (finalColumn.length < size) {
        finalColumn.add(0);
      }

      // Проверка, изменились ли позиции плиток
      if (!moved) {
        moved = !ListEquality()
            .equals(state.board.map((row) => row[col]).toList(), finalColumn);
      }

      for (int row = 0; row < size; row++) {
        state.board[row][col] = finalColumn[row];
      }
    }

    // Генерация новой плитки только если плитки действительно переместились
    if (moved) {
      _generateRandomNumber();
    }

    int newScore = state.score + totalScoreToAdd;
    emit(GameLogicState(newScore, List.from(state.board)));

    if (!hasAvailableMoves()) {
      updateBestScore(newScore);
    }
  }

  void moveDown() {
    int totalScoreToAdd = 0;
    bool moved = false;

    for (int col = size - 1; col >= 0; col--) {
      List<int> newColumn = [];
      for (int row = size - 1; row >= 0; row--) {
        if (state.board[row][col] != 0) {
          newColumn.add(state.board[row][col]);
        }
      }

      // Объединение смежных ячеек
      for (int i = 0; i < newColumn.length - 1; i++) {
        if (newColumn[i] == newColumn[i + 1]) {
          newColumn[i] *= 2;
          totalScoreToAdd += newColumn[i];
          newColumn[i + 1] = 0;
        }
      }

      List<int> finalColumn = [];
      for (int value in newColumn) {
        if (value != 0) {
          finalColumn.insert(0, value);
        }
      }
      while (finalColumn.length < size) {
        finalColumn.insert(0, 0);
      }

      // Проверка, изменились ли позиции плиток
      if (!moved) {
        moved = !ListEquality()
            .equals(state.board.map((row) => row[col]).toList(), finalColumn);
      }
      for (int row = 0; row < size; row++) {
        state.board[row][col] = finalColumn[row];
      }
    }

    // Генерация новой плитки только если плитки действительно переместились
    if (moved) {
      _generateRandomNumber();
    }

    int newScore = state.score + totalScoreToAdd;
    emit(GameLogicState(newScore, List.from(state.board)));

    if (!hasAvailableMoves()) {
      updateBestScore(newScore);
    }
  }
}
