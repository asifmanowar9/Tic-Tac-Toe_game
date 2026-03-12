import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../flame_game/menu_game.dart';
// import '../theme/app_theme.dart';
import 'game_mode_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final logoSize = (shortestSide * 0.18).clamp(50.0, 90.0);
    final buttonWidth = (shortestSide * 0.58).clamp(180.0, 260.0);
    return Scaffold(
      body: Stack(
        children: [
          // Background Flame game
          GameWidget(game: MenuGame()),

          // UI Layer
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: child,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAnimatedCircle(logoSize),
                        SizedBox(width: logoSize * 0.2),
                        _buildAnimatedCross(logoSize),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Game title
                  Text(
                    'Tic Tac Toe',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),

                  const SizedBox(height: 80),

                  // Play button
                  SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const GameModeScreen(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOutCubic;

                                  var tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                            transitionDuration: const Duration(
                              milliseconds: 500,
                            ),
                          ),
                        );
                      },
                      child: const Text('Play Game'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: size * 0.17),
      ),
    );
  }

  Widget _buildAnimatedCross(double size) {
    final thickness = size * 0.17;
    final topOffset = (size - thickness) / 2;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            top: topOffset,
            child: Transform.rotate(
              angle: 45 * 3.14159 / 180,
              child: Container(
                width: size,
                height: thickness,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: topOffset,
            child: Transform.rotate(
              angle: -45 * 3.14159 / 180,
              child: Container(
                width: size,
                height: thickness,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
