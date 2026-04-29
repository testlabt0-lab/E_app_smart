import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:translator/translator.dart';

class ArTranslatorScreen extends StatefulWidget {
  const ArTranslatorScreen({super.key});

  @override
  State<ArTranslatorScreen> createState() => _ArTranslatorScreenState();
}

class _ArTranslatorScreenState extends State<ArTranslatorScreen> {
  CameraController? _cameraController;
  late ImageLabeler _imageLabeler;
  bool _isProcessing = false;
  String _englishLabel = 'Scanning...';
  String _arabicLabel = '';
  final GoogleTranslator _translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    final ImageLabelerOptions options = ImageLabelerOptions(confidenceThreshold: 0.7);
    _imageLabeler = ImageLabeler(options: options);
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (!mounted) return;

    setState(() {});

    _cameraController!.startImageStream((CameraImage image) {
      if (!_isProcessing) {
        _processCameraImage(image);
      }
    });
  }

  Future<void> _processCameraImage(CameraImage image) async {
    setState(() => _isProcessing = true);

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

      final InputImageRotation imageRotation = InputImageRotation.values.firstWhere(
        (r) => r.rawValue == _cameraController!.description.sensorOrientation,
        orElse: () => InputImageRotation.rotation0deg,
      );

      final InputImageFormat inputImageFormat = InputImageFormat.values.firstWhere(
        (f) => f.rawValue == image.format.raw,
        orElse: () => InputImageFormat.nv21,
      );

      final inputImageMetadata = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes.first.bytesPerRow,
      );

      final inputImage = InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);

      final labels = await _imageLabeler.processImage(inputImage);

      if (labels.isNotEmpty && mounted) {
        String bestLabel = labels.first.label;

        if (bestLabel != _englishLabel) {
           final translation = await _translator.translate(bestLabel, from: 'en', to: 'ar');
           setState(() {
             _englishLabel = bestLabel;
             _arabicLabel = translation.text;
           });
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    // Process a frame every 1 second to save battery
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isProcessing = false);
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _imageLabeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('AR Lens Translator')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_cameraController!),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    _englishLabel.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _arabicLabel,
                    style: const TextStyle(color: Colors.amber, fontSize: 24),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
