import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/classifier_service.dart';
import 'package:image_picker/image_picker.dart';
import '../services/gemini_service.dart';

class HomeViewModel extends ChangeNotifier {
  final TfliteService _service = TfliteService();
  final GeminiService _gemini = GeminiService();
  
  File? _image;
  String _label = "Belum ada prediksi";
  String _recommendation = "";
  double _confidence = 0.0;
  bool _isBusy = false;

  // Getters
  File? get image => _image;
  String get label => _label;
  String get recommendation => _recommendation;
  double get confidence => _confidence;
  bool get isBusy => _isBusy;

  // Constructor: Load model saat pertama kali dibuat
  HomeViewModel() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    await _service.loadModel();
    print("Model loaded in ViewModel");
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _label = "Menganalisa...";
      _recommendation = "";
      notifyListeners();
      
      await _classify();
    }
  }

  Future<void> _classify() async {
    if (_image == null) return;
    _isBusy = true;
    notifyListeners();

    var result = await _service.classifyImage(_image!);

    if (result != null && result.isNotEmpty) {
      String rawLabel = result[0]['label'];
      _label = rawLabel.replaceAll(RegExp(r'[0-9]'), '').trim();
      _confidence = result[0]['confidence'];

      // STEP: Trigger Gemini Recommendation
      _recommendation = "Fetching recycling tips...";
      notifyListeners();
      _recommendation = await _gemini.getRecycleRecommendation(_label);
    } else {
      _label = "Unrecognized";
      _recommendation = "";
      _confidence = 0.0;
    }

    _isBusy = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}