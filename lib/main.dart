import 'package:flutter/material.dart';

void main() {
  runApp(const SketchAR());
}

class SketchAR extends StatelessWidget {
  const SketchAR({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SketchAR',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F4EF),
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFDCCFEA),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),

              const Text(
                'SketchAR.',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF39353D),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Tu creatividad, sin límites.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF77717B),
                ),
              ),

              const Spacer(),

              Center(
                child: Container(
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCCFEA),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: const Icon(
                    Icons.draw_rounded,
                    size: 100,
                    color: Color(0xFF39353D),
                  ),
                ),
              ),

              const Spacer(),

              const Text(
                '¿Qué quieres crear hoy?',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF39353D),
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedBuonPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const DrawingScreen(),
    ),
  );
},
tton.styleFrom(
                    backgroundColor: const Color(0xFFDCCFEA),
                    foregroundColor: const Color(0xFF39353D),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Comenzar a dibujar',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: OutlinedButton(
  onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const DrawingScreen(),
    ),
  );
},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF39353D),
                    side: const BorderSide(
                      color: Color(0xFFDCCFEA),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Mis imágenes',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Aprender',
                    style: TextStyle(
                      color: Color(0xFF77717B),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawingScreen extends StatelessWidget {
  const DrawingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      appBar: AppBar(
        title: const Text('Mi espacio de dibujo'),
        backgroundColor: const Color(0xFFF7F4EF),
      ),
      body: const Center(
        child: Text(
          'Aquí comenzará tu experiencia SketchAR',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF39353D),
          ),
        ),
      ),
    );
  }
}