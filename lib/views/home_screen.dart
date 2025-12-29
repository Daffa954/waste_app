import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: Text("Offline Waste AI")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- Gambar ---
                  Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: viewModel.image == null
                        ? Icon(Icons.image, size: 50, color: Colors.grey)
                        : Image.file(viewModel.image!, fit: BoxFit.cover),
                  ),
                  
                  SizedBox(height: 20),

                  // --- Hasil ---
                  viewModel.isBusy
                      ? CircularProgressIndicator()
                      : Column(
                          children: [
                            Text(
                              viewModel.label,
                              style: TextStyle(
                                fontSize: 28, 
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800]
                              ),
                            ),
                            Text(
                              "Confidence: ${(viewModel.confidence * 100).toStringAsFixed(1)}%",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                  
                  SizedBox(height: 40),

                  // --- Tombol ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        heroTag: "cam",
                        onPressed: () => viewModel.pickImage(ImageSource.camera),
                        child: Icon(Icons.camera_alt),
                      ),
                      SizedBox(width: 20),
                      FloatingActionButton(
                        heroTag: "gal",
                        onPressed: () => viewModel.pickImage(ImageSource.gallery),
                        child: Icon(Icons.photo_library),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}