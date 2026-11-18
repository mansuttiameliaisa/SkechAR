import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFDCCFEA)),
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
                style: TextStyle(fontSize: 16, color: Color(0xFF77717B)),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DrawingScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDCCFEA),
                    foregroundColor: const Color(0xFF39353D),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Comenzar a dibujar',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                    side: const BorderSide(color: Color(0xFFDCCFEA), width: 2),
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
                    style: TextStyle(color: Color(0xFF77717B), fontSize: 16),
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

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImage;
  double _opacity = 0.5;
  double _scale = 1;
  Offset _imagePosition = Offset.zero;
  Offset _initialPosition = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;
  double _initialScale = 1;

  CameraController? _controller;
  bool _loading = false;
  String? _error;

  List<CameraDescription> _cameras = const [];
  CameraDescription? _selectedCamera;

  Future<void> _initializeCamera({CameraDescription? target}) async {
    if (_loading) return;
    final previousController = _controller;
    setState(() {
      _controller = null;
      _loading = true;
      _error = null;
    });

    CameraController? pendingController;
    String? error;
    try {
      if (previousController != null) {
        await _disposeCamera(previousController);
      }
      if (!mounted) return;
      final cameras = target == null ? await availableCameras() : _cameras;
      if (!mounted) return;
      _cameras = cameras;
      if (cameras.isEmpty) {
        error = 'No se encontró ninguna cámara en este dispositivo.';
      } else {
        final camera =
            target ??
            cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
              orElse: () => cameras.first,
            );
        pendingController = CameraController(
          camera,
          ResolutionPreset.high,
          enableAudio: false,
        );
        await pendingController.initialize();
        if (!mounted) return;
        _selectedCamera = camera;
        _controller = pendingController;
        pendingController = null;
      }
    } on CameraException catch (exception) {
      error = switch (exception.code) {
        'CameraAccessDenied' || 'CameraAccessDeniedWithoutPrompt' => 'Permite el acceso a la cámara en los ajustes del sitio o del dispositivo y vuelve a intentarlo.',
        'CameraAccessRestricted' =>
          'El acceso a la cámara está restringido en este dispositivo.',
        'cameraNotFound' ||
        'NotFoundError' => 'No se encontró ninguna cámara en este dispositivo.',
        'cameraNotReadable' => 'La cámara no está disponible. Cierra cualquier aplicación que la esté usando y vuelve a intentarlo.',
        'cameraNotSupported' || 'cameraType' || 'cameraSecurity' =>
          'Abre SketchAR directamente en un navegador compatible usando HTTPS.',
        _ => 'No se pudo abrir la cámara. Vuelve a intentarlo.',
      };
      debugPrint('Cámara: ${exception.code}');
    } catch (exception) {
      error = 'No se pudo abrir la cámara. En la web, abre SketchAR usando HTTPS o localhost.';
      debugPrint('Cámara: $exception');
    } finally {
      if (pendingController != null) {
        await _disposeCamera(pendingController);
      }
      if (mounted) {
        setState(() {
          _error = error;
          _loading = false;
        });
      }
    }
  }

  Future<void> _disposeCamera(CameraController controller) async {
    try {
      await controller.dispose();
    } catch (exception) {
      debugPrint('No se pudo liberar la cámara: $exception');
    }
  }

  void _switchCamera() {
    if (_loading || _cameras.length < 2) return;
    final index = _cameras.indexOf(_selectedCamera ?? _cameras.first);
    final next = _cameras[(index + 1) % _cameras.length];
    final opposite = _selectedCamera?.lensDirection == CameraLensDirection.back
        ? CameraLensDirection.front
        : CameraLensDirection.back;
    final target = _cameras.length > 2
        ? _cameras.firstWhere(
            (camera) =>
                camera.lensDirection == opposite && camera != _selectedCamera,
            orElse: () => next,
          )
        : next;
    _initializeCamera(target: target);
  }

  Future<void> _pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null || !mounted) return;
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() {
        _selectedImage = bytes;
        _scale = 1;
        _imagePosition = Offset.zero;
      });
    } catch (exception) {
      debugPrint('Imagen: $exception');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir la imagen. Elige otro archivo.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    final controller = _controller;
    if (controller != null) _disposeCamera(controller);
    super.dispose();
  }

  Widget _buildDrawingArea() {
    final controller = _controller;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (controller != null) CameraPreview(controller),
        if (_selectedImage != null)
          Positioned.fill(
            child: GestureDetector(
              onScaleStart: (details) {
                _initialPosition = _imagePosition;
                _initialFocalPoint = details.localFocalPoint;
                _initialScale = _scale;
              },
              onScaleUpdate: (details) {
                setState(() {
                  _scale = (_initialScale * details.scale).clamp(0.3, 4.0);
                  _imagePosition =
                      _initialPosition +
                      (details.localFocalPoint - _initialFocalPoint);
                });
              },
              child: Center(
                child: Transform.translate(
                  offset: _imagePosition,
                  child: Transform.scale(
                    scale: _scale,
                    child: Opacity(
                      opacity: _opacity,
                      child: Image.memory(
                        _selectedImage!,
                        width: 250,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Text(
                          'No se pudo mostrar la imagen. Prueba con JPG o PNG.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (controller == null)
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_loading)
                    const LinearProgressIndicator()
                  else ...[
                    if (_error case final error?)
                      Text(error, textAlign: TextAlign.center),
                    TextButton.icon(
                      onPressed: () => _initializeCamera(),
                      icon: const Icon(Icons.videocam_outlined),
                      label: Text(
                        _error == null ? 'Activar cámara' : 'Reintentar cámara',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        Positioned(
          bottom: 25,
          left: 20,
          right: 20,
          child: ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: const Text('Elegir imagen'),
          ),
        ),
        Positioned(
          bottom: 95,
          left: 25,
          right: 25,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F4EF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Transparencia',
                  style: TextStyle(
                    color: Color(0xFF39353D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: _opacity,
                  min: 0,
                  max: 1,
                  activeColor: const Color(0xFFB69ACF),
                  onChanged: (value) => setState(() => _opacity = value),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      appBar: AppBar(
        title: const Text('Mi espacio de dibujo'),
        actions: [
          if (_cameras.length > 1)
            IconButton(
              tooltip: 'Cambiar cámara',
              onPressed: _loading ? null : _switchCamera,
              icon: const Icon(Icons.cameraswitch_outlined),
            ),
        ],
        backgroundColor: const Color(0xFFF7F4EF),
      ),
      body: _buildDrawingArea(),
    );
  }
}
