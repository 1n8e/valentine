import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import '../widgets/floating_hearts.dart';

class AcceptedScreen extends StatefulWidget {
  const AcceptedScreen({super.key});

  @override
  State<AcceptedScreen> createState() => _AcceptedScreenState();
}

class _AcceptedScreenState extends State<AcceptedScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _floatingHeartsController;
  late Animation<double> _heartScale;
  final List<FloatingHeart> _floatingHearts = [];
  final Random _random = Random();

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

  Future<void> _openLocation() async {
    final uri = Uri.parse('https://go.2gis.com/qvPLL');
    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );
    }
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

                  final emojiSize = isSmallScreen ? 60.0 : 80.0;
                  final titleSize = isSmallScreen ? 36.0 : 48.0;
                  final heartSize = isSmallScreen ? 80.0 : 120.0;
                  final textSize = isSmallScreen ? 22.0 : 28.0;
                  final subtextSize = isSmallScreen ? 16.0 : 20.0;
                  final buttonFontSize = isSmallScreen ? 14.0 : 18.0;
                  final smallHeartSize = isSmallScreen ? 22.0 : 28.0;
                  final spacing = isSmallScreen ? 15.0 : 30.0;
                  final heartCount = isNarrow ? 5 : (isSmallScreen ? 5 : 7);

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
                                  TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.elasticOut,
                                    builder: (context, value, child) {
                                      return Transform.scale(
                                        scale: value,
                                        child: Text(
                                          '🎉',
                                          style: TextStyle(fontSize: emojiSize),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: spacing * 0.5),
                                  TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 600),
                                    builder: (context, value, child) {
                                      return Opacity(
                                        opacity: value,
                                        child: Transform.translate(
                                          offset: Offset(0, (1 - value) * 30),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'УРА!!!',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: titleSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: const [
                                          Shadow(
                                            blurRadius: 15,
                                            color: Colors.black38,
                                            offset: Offset(3, 3),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: spacing),
                                  ScaleTransition(
                                    scale: _heartScale,
                                    child: Text(
                                      '❤️',
                                      style: TextStyle(fontSize: heartSize),
                                    ),
                                  ),
                                  SizedBox(height: spacing),
                                  Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 80,
                                      minWidth: 200,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSmallScreen ? 20 : 30,
                                      vertical: isSmallScreen ? 15 : 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.white
                                            .withValues(alpha: 0.4),
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Я так счастлив! 🥰',
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: textSize,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                            height: isSmallScreen ? 10 : 15),
                                        Text(
                                          'Это будет лучшее свидание!',
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: subtextSize,
                                            color: Colors.white
                                                .withValues(alpha: 0.9),
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: spacing),
                                  TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    builder: (context, value, child) {
                                      return Opacity(
                                        opacity: value,
                                        child: Transform.scale(
                                          scale: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minHeight: 48,
                                      ),
                                      child: ElevatedButton.icon(
                                        onPressed: _openLocation,
                                        icon: Icon(
                                          Icons.location_on,
                                          size: isSmallScreen ? 22 : 28,
                                        ),
                                        label: Text(
                                          'Смотри, где встретимся! 📍',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: buttonFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.pink.shade600,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isSmallScreen ? 18 : 25,
                                            vertical: isSmallScreen ? 12 : 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          elevation: 10,
                                          shadowColor: Colors.black38,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: spacing),
                                  // Используем Wrap для сердечек - reflow на маленьких экранах
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: List.generate(
                                      heartCount,
                                      (index) => TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        duration: Duration(
                                            milliseconds: 400 + index * 150),
                                        builder: (context, value, child) {
                                          return Opacity(
                                            opacity: value,
                                            child: Transform.translate(
                                              offset:
                                                  Offset(0, (1 - value) * 30),
                                              child: Text(
                                                [
                                                  '💖',
                                                  '💕',
                                                  '💗',
                                                  '💓',
                                                  '💗',
                                                  '💕',
                                                  '💖'
                                                ][index],
                                                style: TextStyle(
                                                    fontSize: smallHeartSize),
                                              ),
                                            ),
                                          );
                                        },
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
