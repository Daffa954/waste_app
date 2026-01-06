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
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF667eea),
                    Color(0xFF764ba2),
                    Color(0xFFF093FB),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header (Kept original)
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(Icons.recycling, color: Colors.white, size: 28),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Waste AI",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                "Smart Waste Classification",
                                style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Main Content Card
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Column(
                              children: [
                                // Image Display (Kept original)
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: 250, // Slightly reduced height to fit text
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: viewModel.image == null
                                        ? LinearGradient(colors: [Color(0xFFF5F7FA), Color(0xFFE8ECF1)])
                                        : null,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF667eea).withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: viewModel.image == null
                                        ? Center(
                                            child: Icon(Icons.add_photo_alternate_outlined, size: 60, color: Colors.grey[400]),
                                          )
                                        : Image.file(viewModel.image!, fit: BoxFit.cover),
                                  ),
                                ),

                                SizedBox(height: 24),

                                // Results Section
                                if (viewModel.isBusy)
                                  Column(
                                    children: [
                                      CircularProgressIndicator(color: Color(0xFF667eea)),
                                      SizedBox(height: 16),
                                      Text("Analyzing...", style: TextStyle(color: Colors.grey[600])),
                                    ],
                                  )
                                else if (viewModel.image != null)
                                  Column(
                                    children: [
                                      // 1. Classification Result
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF5F7FA),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Color(0xFF667eea).withOpacity(0.2)),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              viewModel.label,
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF667eea),
                                              ),
                                            ),
                                            Text(
                                              "${(viewModel.confidence * 100).toStringAsFixed(1)}% Confidence",
                                              style: TextStyle(color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      SizedBox(height: 16),

                                      // 2. Gemini AI Info Section
                                      if (viewModel.wasteInfo.isNotEmpty)
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Color(0xFF764ba2).withOpacity(0.1), Color(0xFF667eea).withOpacity(0.05)],
                                            ),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: Color(0xFF764ba2).withOpacity(0.2)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.lightbulb, color: Colors.amber, size: 24),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "AI Insights",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF764ba2),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                              Text(
                                                viewModel.wasteInfo,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  height: 1.5,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),

                                SizedBox(height: 24),

                                // Action Buttons (Kept original structure)
                                Row(
                                  children: [
                                    Expanded(
                                      child: _ActionButton(
                                        icon: Icons.camera_alt,
                                        label: "Camera",
                                        gradient: LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                                        onTap: () => viewModel.pickImage(ImageSource.camera),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: _ActionButton(
                                        icon: Icons.photo_library,
                                        label: "Gallery",
                                        gradient: LinearGradient(colors: [Color(0xFF764ba2), Color(0xFFF093FB)]),
                                        onTap: () => viewModel.pickImage(ImageSource.gallery),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// _ActionButton class remains exactly the same as in your original file
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16), // Slightly reduced padding
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.4),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}