import 'package:flutter_test/flutter_test.dart';
import 'package:sketchar/main.dart';
import 'dart:ui';

void main() {
  testWidgets('Shows the SketchAR home screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const SketchAR());

    expect(find.text('SketchAR.'), findsOneWidget);
    expect(find.text('Comenzar a dibujar'), findsOneWidget);
    expect(find.text('Mis imágenes'), findsOneWidget);
  });
}
