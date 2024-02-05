import 'package:flutter/material.dart';
import 'dart:math';
import 'package:animations/animations.dart';

void main() {
 runApp(
  MaterialApp(
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(),
      ).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      home: const FoodRandomizerApp(),
    ),
  );
}

class Food {
  final String name;
  final int calories;
  String image;

  Food(this.name, this.calories, this.image);
}

class FoodRandomizerApp extends StatefulWidget {
  const FoodRandomizerApp({super.key});

  @override
  _FoodRandomizerAppState createState() => _FoodRandomizerAppState();
}

class _FoodRandomizerAppState extends State<FoodRandomizerApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool started = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void startApp() {
    setState(() {
      started = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return started
        ? FoodRandomizerScreen(onBack: () {})
        : _buildStartScreen();
  }

  Widget _buildStartScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to Dice&Dine',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[600],
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            ClipPath(
              clipper: UpperHalfClipper(),
              child: Container(
                color: Colors.red[600],
              ),
            ),
            CustomPaint(
              painter: WavyLinePainter(),
              child: Container(),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  startApp();
                  navigatorKey.currentState?.push<void>(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return FoodRandomizerScreen(onBack: () {});
                      },
                    ),
                  );
                },
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for upper half
class UpperHalfClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height / 2)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height / 2)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom Painter for wavy line
class WavyLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(0, size.height / 2)
      ..quadraticBezierTo(
          size.width / 4, size.height / 2 - 20, size.width / 2, size.height / 2)
      ..quadraticBezierTo(3 * size.width / 4, size.height / 2 + 20, size.width,
          size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FoodRandomizerScreen extends StatefulWidget {
  final VoidCallback onBack;
  const FoodRandomizerScreen({super.key, required this.onBack});

  @override
  _FoodRandomizerScreenState createState() => _FoodRandomizerScreenState();
}

class _FoodRandomizerScreenState extends State<FoodRandomizerScreen> {
  final List<Food> allFoods = [
    Food('1 Slice of Pizza', 300, "assets/images/pizza.jpg"),
    Food('Burger', 500, "assets/images/Burger.jpg"),
    Food('5 pieces of Sushi', 400, "assets/images/Sushi.jpg"),
    Food('300 grams of Pasta', 450, "assets/images/Pasta.jpg"),
    Food('Bowl of Salad', 150, "assets/images/Salad.jpg"),
    Food('Tacos', 450, "assets/images/Tacos.webp"),
    Food('Ice Cream Cone', 250, "assets/images/Ice Cream.jpg"),
    Food('Steak', 600, "assets/images/Steak.jpg"),
    Food('Chicken Rice', 450, "assets/images/Chicken Rice.jpg"),
    Food('Soup', 200, "assets/images/Soup.jpg"),
    Food('Krapow with Fried Egg', 450, "assets/images/Krapow.jpg")
  ];

  List<Food> selectedFoods = [];
  int totalCalories = 0;

  void randomizeFood() {
    final Random random = Random();
    final List<Food> remainingFoods = List.from(allFoods);

    if (remainingFoods.length < 3) {
      return;
    }

    for (int i = 0; i < 3; i++) {
      final int randomNumber = random.nextInt(remainingFoods.length);
      final Food selectedFood = remainingFoods.removeAt(randomNumber);
      selectedFoods.add(selectedFood);
      totalCalories += selectedFood.calories;

      if (remainingFoods.isEmpty) {
        break;
      }
    }

    setState(() {});
  }

  void resetFoods() {
    selectedFoods.clear();
    totalCalories = 0;
    setState(() {});
  }

  void backToStart() {
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dine&Dine', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            onPressed: backToStart,
          ),
        ],
      ),
      body: Container(
        color: Colors.red[600],
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selectedFoods.isNotEmpty)
                    const Text(
                      'Today\'s Food:',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  if (selectedFoods.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedFoods.length,
                        itemBuilder: (context, index) {
                          Food food = selectedFoods[index];
                          return Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    food.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                '${food.name} - ${food.calories} Calories',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (totalCalories > 0)
                    Text(
                      'Total Calories: $totalCalories',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: randomizeFood,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child:const Text('Dine&Dine'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: resetFoods,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child:const Text('Reset Food')
                  ),
                  const SizedBox(height: 20), // Add spacing
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow, // or any color you prefer
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset:const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/burger.png", // Replace with your image asset
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
