import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/classifier_service.dart';
import 'package:flutter_application_1/services/gemini_service.dart'; // Import Gemini Service
import 'package:image_picker/image_picker.dart';

class HomeViewModel extends ChangeNotifier {
  final TfliteService _classifierService = TfliteService();
  final GeminiService _geminiService = GeminiService(); // Instance of Gemini Service
  
  File? _image;
  String _label = "Belum ada prediksi";
  double _confidence = 0.0;
  bool _isBusy = false;
  
  // New variable to store Gemini response
  String _wasteInfo = "";

  // Getters
  File? get image => _image;
  String get label => _label;
  double get confidence => _confidence;
  bool get isBusy => _isBusy;
  String get wasteInfo => _wasteInfo; // Expose waste info

  HomeViewModel() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    await _classifierService.loadModel();
    print("Model loaded in ViewModel");
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _label = "Menganalisa...";
      _wasteInfo = ""; // Reset previous info
      notifyListeners();
      
      await _classify();
    }
  }

  Future<void> _classify() async {
    if (_image == null) return;
    
    _isBusy = true;
    notifyListeners();

    // 1. Classify using TFLite
    var result = await _classifierService.classifyImage(_image!);

    if (result != null && result.isNotEmpty) {
      String rawLabel = result[0]['label'];
      // Clean up label (remove numbers)
      String cleanLabel = rawLabel.replaceAll(RegExp(r'[0-9]'), '').trim();
      
      _label = cleanLabel;
      _confidence = result[0]['confidence'];

      // 2. Fetch Fun Fact & Steps from Gemini
      // Only ask Gemini if confidence is decent (optional check)
      if (_confidence > 0.5) {
         _wasteInfo = "Loading AI insights...";
         notifyListeners(); // Update UI to show loading state for text
         
         String aiResponse = await _geminiService.getWasteInfo(cleanLabel);
         _wasteInfo = aiResponse;
      }

    } else {
      _label = "Tidak dikenali";
      _confidence = 0.0;
      _wasteInfo = "";
    }

    _isBusy = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _classifierService.dispose();
    super.dispose();
  }
}