import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class GameState extends ChangeNotifier {
  // Game state
  List<List<String>> board =
      List.generate(3, (_) => List.generate(3, (_) => ''));
  String currentPlayer = 'X'; // X starts first
  bool gameOver = false;
  bool isProfilePictureMode = false;
  List<List<int>> winningCells = [];

  // Profile picture mode state
  PlatformFile? playerOneImage;
  PlatformFile? playerTwoImage;

  // Context for showing popups
  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  // Toggle between X/O mode and Profile Picture mode
  void toggleGameMode() {
    isProfilePictureMode = !isProfilePictureMode;
    resetGame();
    notifyListeners();
  }

  Future<void> pickImage(bool isPlayerOne) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result == null) return;

      final PlatformFile file = result.files.first;

      if (isPlayerOne) {
        playerOneImage = file;
      } else {
        playerTwoImage = file;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  // Make a move on the board
  void makeMove(int row, int col) {
    if (board[row][col].isEmpty && !gameOver) {
      // Check if profile pictures are selected in Profile Picture Mode
      if (isProfilePictureMode) {
        if ((currentPlayer == 'X' && playerOneImage == null) ||
            (currentPlayer == 'O' && playerTwoImage == null)) {
          _showImageSelectionError();
          return;
        }
      }

      board[row][col] = currentPlayer;
      checkWinner();
      if (!gameOver) {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
      notifyListeners();
    }
  }

  // Check for a winner or draw
  void checkWinner() {
    List<List<List<int>>> winPatterns = [
      // Rows
      [
        [0, 0],
        [0, 1],
        [0, 2]
      ],
      [
        [1, 0],
        [1, 1],
        [1, 2]
      ],
      [
        [2, 0],
        [2, 1],
        [2, 2]
      ],
      // Columns
      [
        [0, 0],
        [1, 0],
        [2, 0]
      ],
      [
        [0, 1],
        [1, 1],
        [2, 1]
      ],
      [
        [0, 2],
        [1, 2],
        [2, 2]
      ],
      // Diagonals
      [
        [0, 0],
        [1, 1],
        [2, 2]
      ],
      [
        [0, 2],
        [1, 1],
        [2, 0]
      ],
    ];

    for (var pattern in winPatterns) {
      String first = board[pattern[0][0]][pattern[0][1]];
      if (first.isNotEmpty &&
          first == board[pattern[1][0]][pattern[1][1]] &&
          first == board[pattern[2][0]][pattern[2][1]]) {
        winningCells = pattern;
        gameOver = true;
        notifyListeners();
        if (_context != null) {
          _showGameResultPopup(_context!, 'Player $currentPlayer Wins!');
        }
        return;
      }
    }

    if (!board.any((row) => row.contains(''))) {
      gameOver = true; // Draw case
      notifyListeners();
      if (_context != null) {
        _showGameResultPopup(_context!, 'Draw');
      }
    }
  }

  // Check if a cell is part of the winning line
  bool isWinningCell(int row, int col) {
    return winningCells.any((cell) => cell[0] == row && cell[1] == col);
  }

  Widget getProfilePicture(int row, int col) {
    PlatformFile? file;

    if (board[row][col] == 'X') {
      file = playerOneImage;
    } else if (board[row][col] == 'O') {
      file = playerTwoImage;
    }

    if (file == null) {
      return Container();
    }

    if (file.bytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.memory(
          file.bytes!,
          fit: BoxFit.cover,
        ),
      );
    }

    if (file.path != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.file(
          File(file.path!),
          fit: BoxFit.cover,
        ),
      );
    }

    return Container();
  }

  // Reset the game
  void resetGame() {
    board = List.generate(3, (_) => List.generate(3, (_) => ''));
    currentPlayer = 'X';
    gameOver = false;
    winningCells = [];
    playerOneImage = null;
    playerTwoImage = null;
    notifyListeners();
  }

  // Show a popup for game result (win or draw)
  void _showGameResultPopup(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.purple.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                result == 'Draw'
                    ? Icons.emoji_emotions_outlined
                    : Icons.celebration,
                size: 60,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                result,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  resetGame();
                },
                child: const Text('Play Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show an error popup if a player hasn't selected an image
  void _showImageSelectionError() {
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text(
            currentPlayer == 'X'
                ? 'Player 1: Please select a profile picture!'
                : 'Player 2: Please select a profile picture!',
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
