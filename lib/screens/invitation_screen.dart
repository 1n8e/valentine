import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/floating_hearts.dart';
import 'accepted_screen.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({super.key});

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _floatingHeartsController;
  late Animation<double> _heartScale;
  final List<FloatingHeart> _floatingHearts = [];
  final Random _random = Random();

  double _noButtonX = 0;
  double _noButtonY = 0;
  int _noButtonEscapeCount = 0;

  final List<String> _escapeMessages = [
    'Нет',
    'Точно нет?',
    'Подумай ещё!',
    'Ну пожааалуйста',
    'Я буду грустить 😢',
    'Ты уверена?',
    'А если конфетку дам?',
    'Последний шанс!',
  ];

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _heartScale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );

    _floatingHeartsController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    for (int i = 0; i < 15; i++) {
      _floatingHearts.add(FloatingHeart(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 20 + 10,
        speed: _random.nextDouble() * 0.5 + 0.2,
        opacity: _random.nextDouble() * 0.4 + 0.2,
      ));
    }
  }

  @override
  void dispose() {
    _heartController.dispose();
    _floatingHeartsController.dispose();
    super.dispose();
  }

  void _escapeNoButton() {
    setState(() {
      final size = MediaQuery.of(context).size;
      // Ограничиваем движение кнопки в пределах экрана
      final maxX = (size.width * 0.25).clamp(40.0, 100.0);
      const maxY = 50.0;

      _noButtonX = (_random.nextDouble() * 2 - 1) * maxX;
      _noButtonY = (_random.nextDouble() * 2 - 1) * maxY;

      // Гарантируем что кнопка не выйдет за правый край
      _noButtonX = _noButtonX.clamp(-maxX, size.width * 0.1);
      _noButtonY = _noButtonY.clamp(-maxY, maxY);

      _noButtonEscapeCount++;
    });
  }

  void _acceptDate() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AcceptedScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFB6C1),
              Color(0xFFFF69B4),
              Color(0xFFFF1493),
              Color(0xFFDC143C),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background overlay - допустимо использовать Stack
            AnimatedBuilder(
              animation: _floatingHeartsController,
              builder: (context, child) {
                return CustomPaint(
                  painter: FloatingHeartsPainter(
                    hearts: _floatingHearts,
                    progress: _floatingHeartsController.value,
                  ),
                  size: Size.infinite,
                );
              },
            ),
            // Main content
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isSmallScreen = constraints.maxHeight < 700;
                  final isNarrow = constraints.maxWidth < 360;

                  final heartSize = isSmallScreen ? 60.0 : 80.0;
                  final nameSize = isSmallScreen ? 28.0 : 36.0;
                  final questionSize = isSmallScreen ? 22.0 : 28.0;
                  final buttonFontSize = isSmallScreen ? 18.0 : 22.0;
                  final buttonPaddingH = isSmallScreen ? 25.0 : 40.0;
                  final buttonPaddingV = isSmallScreen ? 14.0 : 18.0;
                  final spacing = isSmallScreen ? 20.0 : 30.0;

                  return Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ScaleTransition(
                                    scale: _heartScale,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.red.withValues(alpha: 0.5),
                                            blurRadius: 30,
                                            spreadRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '💕',
                                        style: TextStyle(fontSize: heartSize),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: spacing),
                                  Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 50,
                                      minWidth: 80,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      'Гулбиби',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: nameSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: const [
                                          Shadow(
                                            blurRadius: 10,
                                            color: Colors.black26,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: spacing),
                                  Text(
                                    '14 февраля 18:00',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 18.0 : 22.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withValues(alpha: 0.9),
                                      letterSpacing: 1.2,
                                      shadows: const [
                                        Shadow(
                                          blurRadius: 6,
                                          color: Colors.black26,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: spacing),
                                  Text(
                                    'Пойдёшь со мной\nна свидание?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: questionSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      height: 1.3,
                                      shadows: const [
                                        Shadow(
                                          blurRadius: 8,
                                          color: Colors.black26,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: spacing + 20),
                                  // Используем Wrap для кнопок - reflow на маленьких экранах
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 20,
                                    runSpacing: 16,
                                    children: [
                                      ElevatedButton(
                                        onPressed: _acceptDate,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isNarrow
                                                ? buttonPaddingH * 0.7
                                                : buttonPaddingH,
                                            vertical: buttonPaddingV,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          elevation: 8,
                                          shadowColor: Colors.green
                                              .withValues(alpha: 0.5),
                                        ),
                                        child: Text(
                                          'Да! 💖',
                                          style: TextStyle(
                                            fontSize: buttonFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TweenAnimationBuilder<Offset>(
                                        tween: Tween(
                                          begin: Offset.zero,
                                          end: Offset(_noButtonX, _noButtonY),
                                        ),
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeOut,
                                        builder: (context, offset, child) {
                                          return Transform.translate(
                                            offset: offset,
                                            child: child,
                                          );
                                        },
                                        child: MouseRegion(
                                          onEnter: (_) => _escapeNoButton(),
                                          child: GestureDetector(
                                            onTapDown: (_) => _escapeNoButton(),
                                            onPanUpdate: (_) =>
                                                _escapeNoButton(),
                                            child: ElevatedButton(
                                              onPressed: _escapeNoButton,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red.shade400,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: isNarrow
                                                      ? buttonPaddingH * 0.7
                                                      : buttonPaddingH,
                                                  vertical: buttonPaddingV,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                elevation: 8,
                                                shadowColor: Colors.red
                                                    .withValues(alpha: 0.5),
                                              ),
                                              child: Text(
                                                _escapeMessages[
                                                    _noButtonEscapeCount %
                                                        _escapeMessages.length],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: buttonFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_noButtonEscapeCount > 3)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Text(
                                        'Кнопка "Нет" убежала $_noButtonEscapeCount раз 😏',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 14 : 16,
                                          color: Colors.white
                                              .withValues(alpha: 0.8),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
