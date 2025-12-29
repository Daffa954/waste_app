import 'dart:io';
import 'package:flutter_tflite/flutter_tflite.dart';

class TfliteService {
  // Load Model
  Future<String?> loadModel() async {
    try {
      return await Tflite.loadModel(
        model: "model_ai/model_sampah.tflite",
        labels: "model_ai/labels.txt",
        numThreads: 1, // 1 thread agar tidak panas
        isAsset: true,
        useGpuDelegate: false,
      );
    } catch (e) {
      print("Error loading model: $e");
      return null;
    }
  }

  // Klasifikasi Gambar
  Future<List<dynamic>?> classifyImage(File image) async {
    try {
      var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,    // Ambil 2 prediksi teratas
        threshold: 0.5,   // Tampilkan jika confidence > 50%
        imageMean: 127.5, // Standar Teachable Machine
        imageStd: 127.5,  // Standar Teachable Machine
      );
      return output;
    } catch (e) {
      print("Error classifying: $e");
      return null;
    }
  }

  // Bersihkan Memory
  void dispose() {
    Tflite.close();
  }
}