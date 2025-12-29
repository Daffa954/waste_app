import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/classifier_service.dart';
import 'package:image_picker/image_picker.dart';

class HomeViewModel extends ChangeNotifier {
  final TfliteService _service = TfliteService();
  
  File? _image;
  String _label = "Belum ada prediksi";
  double _confidence = 0.0;
  bool _isBusy = false;

  // Getters
  File? get image => _image;
  String get label => _label;
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
      // Format hasil biasanya: "0 Plastic"
      String rawLabel = result[0]['label'];
      // Kita hapus angkanya agar bersih
      _label = rawLabel.replaceAll(RegExp(r'[0-9]'), '').trim();
      _confidence = result[0]['confidence'];
    } else {
      _label = "Tidak dikenali";
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