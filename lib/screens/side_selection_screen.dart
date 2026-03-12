import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../flame_game/background_game.dart';
import '../flame_game/tic_tac_toe_game.dart';
import '../theme/app_theme.dart';

class SideSelectionScreen extends StatefulWidget {
  final bool isAI;

  const SideSelectionScreen({super.key, required this.isAI});

  @override
  State<SideSelectionScreen> createState() => _SideSelectionScreenState();
}

class _SideSelectionScreenState extends State<SideSelectionScreen>
    with SingleTickerProviderStateMixin {
  // Use a ValueNotifier instead of a simple String variable
  final ValueNotifier<String?> _selectedSideNotifier = ValueNotifier<String?>(
    null,
  );
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _selectedSideNotifier
        .dispose(); // Don't forget to dispose the ValueNotifier
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Flame game for particles
          GameWidget(game: BackgroundGame()),

          // UI Layer
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Choose your side',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 60),

                  // Symbols selection row using ValueListenableBuilder
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // X Symbol
                      _buildSymbol(
                        isX: true,
                        onSelect: () {
                          _selectedSideNotifier.value = 'X';
                          _animationController.forward();
                        },
                      ),

                      const SizedBox(width: 40),

                      // O Symbol
                      _buildSymbol(
                        isX: false,
                        onSelect: () {
                          _selectedSideNotifier.value = 'O';
                          _animationController.forward();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // Start game button
                  ValueListenableBuilder<String?>(
                    valueListenable: _selectedSideNotifier,
                    builder: (context, selectedSide, _) {
                      final buttonWidth =
                          (MediaQuery.of(context).size.shortestSide * 0.58)
                              .clamp(180.0, 260.0);
                      return SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton(
                          onPressed: selectedSide != null
                              ? () => _startGame(context, selectedSide)
                              : null,
                          child: const Text('Start Game'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Back button
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text(
                      'Back',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymbol({required bool isX, required VoidCallback onSelect}) {
    return ValueListenableBuilder<String?>(
      valueListenable: _selectedSideNotifier,
      builder: (context, selectedSide, _) {
        final isSelected =
            (isX && selectedSide == 'X') || (!isX && selectedSide == 'O');
        final base = (MediaQuery.of(context).size.shortestSide * 0.21).clamp(
          70.0,
          100.0,
        );
        final boxSize = isSelected ? base * 1.2 : base;

        return GestureDetector(
          onTap: onSelect,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white.withAlpha(100),
              borderRadius: BorderRadius.circular(isX ? 16 : 50),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(
                          red: 0,
                          green: 0,
                          blue: 0,
                          alpha: 51,
                        ),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isX
                  ? _buildCross(
                      size: isSelected ? boxSize * 0.7 : boxSize * 0.63,
                      thickness: isSelected ? boxSize * 0.15 : boxSize * 0.13,
                      color: AppTheme.primaryColor,
                    )
                  : Container(
                      width: isSelected ? boxSize * 0.7 : boxSize * 0.63,
                      height: isSelected ? boxSize * 0.7 : boxSize * 0.63,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: isSelected ? boxSize * 0.15 : boxSize * 0.13,
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCross({
    required double size,
    required double thickness,
    required Color color,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            top: (size - thickness) / 2,
            child: Transform.rotate(
              angle: 45 * 3.14159 / 180,
              child: Container(width: size, height: thickness, color: color),
            ),
          ),
          Positioned(
            top: (size - thickness) / 2,
            child: Transform.rotate(
              angle: -45 * 3.14159 / 180,
              child: Container(width: size, height: thickness, color: color),
            ),
          ),
        ],
      ),
    );
  }

  void _startGame(BuildContext context, String playerSymbol) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            GameScreen(isAI: widget.isAI, playerSymbol: playerSymbol),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  final bool isAI;
  final String playerSymbol;

  const GameScreen({super.key, required this.isAI, required this.playerSymbol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: TicTacToeGame(
          isAI: isAI,
          playerSymbol: playerSymbol,
          context: context,
        ),
      ),
    );
  }
}
