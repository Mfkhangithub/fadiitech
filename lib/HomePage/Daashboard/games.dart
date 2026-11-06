import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:websidefadii/Provider/gamestate.dart';

class TicTacToePage extends StatelessWidget {
  const TicTacToePage({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    gameState.setContext(context); // Set the context for showing popups

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.purple.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Game Mode Toggle Button
              ElevatedButton(
                onPressed: gameState.toggleGameMode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  gameState.isProfilePictureMode
                      ? 'Switch to X/O Mode'
                      : 'Switch to Profile Picture Mode',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Player Profile Picture Selection
              if (gameState.isProfilePictureMode) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Player 1',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => gameState.pickImage(true),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: gameState.playerOneImage != null
                                ? (kIsWeb
                                        ? MemoryImage(
                                            gameState.playerOneImage!.bytes!)
                                        : FileImage(File(
                                            gameState.playerOneImage!.path!)))
                                    as ImageProvider
                                : null,
                            child: gameState.playerOneImage == null
                                ? const Icon(Icons.add_a_photo,
                                    size: 40, color: Colors.white)
                                : null,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Player 2',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => gameState.pickImage(false),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: gameState.playerTwoImage != null
                                ? (kIsWeb
                                        ? MemoryImage(
                                            gameState.playerTwoImage!.bytes!)
                                        : FileImage(File(
                                            gameState.playerTwoImage!.path!)))
                                    as ImageProvider
                                : null,
                            child: gameState.playerTwoImage == null
                                ? const Icon(Icons.add_a_photo,
                                    size: 40, color: Colors.white)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // Game Board
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: List.generate(3, (row) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (col) {
                        return GestureDetector(
                          onTap: () => gameState.makeMove(row, col),
                          child: Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: gameState.isWinningCell(row, col)
                                  ? Colors.green.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.5),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: gameState.isProfilePictureMode
                                  ? gameState.getProfilePicture(row, col)
                                  : Text(
                                      gameState.board[row][col],
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: gameState.board[row][col] == 'X'
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),

              // Current Player
              Text(
                gameState.gameOver
                    ? 'Game Over'
                    : 'Player ${gameState.currentPlayer}\'s Turn',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Reset Button
              ElevatedButton(
                onPressed: gameState.resetGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Reset Game',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
