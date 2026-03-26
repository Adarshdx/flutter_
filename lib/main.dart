import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productivity Pro Max',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const DoNothingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DoNothingScreen extends StatefulWidget {
  const DoNothingScreen({super.key});

  @override
  State<DoNothingScreen> createState() => _DoNothingScreenState();
}

class _DoNothingScreenState extends State<DoNothingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;
  int _timeWasted = 0;
  Timer? _wasteTimer;
  final List<String> _funnyQuotes = [
    "Still waiting...",
    "Wow! You're really good at wasting time! 🏆",
    "This app has 100% success rate at doing nothing!",
    "Your productivity level: -∞",
    "Congratulations! You achieved nothing! 🎉",
    "Boss mode: Activated for doing nothing",
    "Time flies when you're doing nothing",
    "Your future self is disappointed 😂",
    "This button does even less than nothing!",
    "404 Productivity Not Found",
    "You're officially a professional time waster! 🏅",
    "Netflix called, they want their time back",
  ];

  @override
  void initState() {
    super.initState();
    
    // Animation setup
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    // Start wasting time counter
    _wasteTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _timeWasted++;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _wasteTimer?.cancel();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.emoji_emotions, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.purple.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
      ),
    );
  }
  
  void _showRandomQuote() {
    final randomQuote = _funnyQuotes[Random().nextInt(_funnyQuotes.length)];
    _showSnackBar(context, randomQuote);
  }
  
  String _formatTimeWasted() {
    final hours = _timeWasted ~/ 3600;
    final minutes = (_timeWasted % 3600) ~/ 60;
    final seconds = _timeWasted % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Productivity Pro Max',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 5),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: value * 2 * pi,
                  child: child,
                );
              },
              child: const Text(' 🚀', style: TextStyle(fontSize: 24)),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.shade800.withOpacity(0.8),
                Colors.pink.shade600.withOpacity(0.8),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade900,
              Colors.pink.shade700,
              Colors.orange.shade600,
            ],
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: _showRandomQuote,
            child: Stack(
              children: [
                // Animated floating shapes in background
                ...List.generate(5, (index) {
                  return Positioned(
                    left: Random().nextDouble() * MediaQuery.of(context).size.width,
                    top: Random().nextDouble() * MediaQuery.of(context).size.height,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(seconds: Random().nextInt(5) + 3),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: 0.1 + (value * 0.1),
                          child: Transform.translate(
                            offset: Offset(
                              sin(value * 2 * pi) * 20,
                              cos(value * 2 * pi) * 20,
                            ),
                            child: Container(
                              width: 50 + index * 10,
                              height: 50 + index * 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
                
                // Main content
                Center(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.2),
                                  Colors.white.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Animated icon
                                TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: const Duration(seconds: 2),
                                  builder: (context, value, child) {
                                    return Transform.rotate(
                                      angle: value * 2 * pi,
                                      child: Icon(
                                        Icons.timer_off_outlined,
                                        size: 80 + (value * 20),
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                
                                // Main funny text
                                const Text(
                                  'I do nothing except wasting your time 😌',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10,
                                        color: Colors.black26,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 40),
                                
                                // Fake loading spinner
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        'Loading something important...',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Fake stats card at bottom
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Tasks Completed',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              '0',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        Column(
                          children: [
                            const Text(
                              'Time Wasted',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _formatTimeWasted(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showSnackBar(context, 'Still doing nothing 😂');
        },
        icon: const Icon(Icons.do_not_disturb),
        label: const Text('Do Nothing'),
        backgroundColor: Colors.purple.shade800,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade900.withOpacity(0.9),
                Colors.pink.shade800.withOpacity(0.9),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showSnackBar(context, 'Nice try! Still nothing happens 🤪');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Start Working'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
