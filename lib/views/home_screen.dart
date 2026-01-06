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
                    // Header
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.recycling,
                                  color: Colors.white,
                                  size: 28,
                                ),
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
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
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
                                // Image Display
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: 320,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: viewModel.image == null
                                        ? LinearGradient(
                                            colors: [
                                              Color(0xFFF5F7FA),
                                              Color(0xFFE8ECF1),
                                            ],
                                          )
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
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_photo_alternate_outlined,
                                                size: 80,
                                                color: Colors.grey[400],
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                "No image selected",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[500],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Tap below to capture or select",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ],
                                          )
                                        : Image.file(
                                            viewModel.image!,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),

                                SizedBox(height: 32),

                                // Results Section
                                AnimatedSwitcher(
                                  duration: Duration(milliseconds: 400),
                                  child: viewModel.isBusy
                                      ? Column(
                                          key: ValueKey('loading'),
                                          children: [
                                            CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                Color(0xFF667eea),
                                              ),
                                              strokeWidth: 3,
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              "Analyzing...",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                      : viewModel.image != null
                                          ? Container(
                                              key: ValueKey('result'),
                                              padding: EdgeInsets.all(24),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xFF667eea).withOpacity(0.1),
                                                    Color(0xFF764ba2).withOpacity(0.1),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Color(0xFF667eea).withOpacity(0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Classification Result",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[600],
                                                      fontWeight: FontWeight.w500,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                  SizedBox(height: 12),
                                                  Text(
                                                    viewModel.label,
                                                    style: TextStyle(
                                                      fontSize: 32,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF667eea),
                                                      letterSpacing: 0.5,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 16),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.verified,
                                                        color: Color(0xFF764ba2),
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        "${(viewModel.confidence * 100).toStringAsFixed(1)}% Confidence",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.grey[700],
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 12),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: LinearProgressIndicator(
                                                      value: viewModel.confidence,
                                                      backgroundColor: Colors.grey[200],
                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                        Color(0xFF667eea),
                                                      ),
                                                      minHeight: 6,
                                                    ),
                                                  ),
                                                  if (viewModel.recommendation.isNotEmpty) ...[
                                                    SizedBox(height: 20),
                                                    Divider(color: Color(0xFF667eea).withOpacity(0.3)),
                                                    SizedBox(height: 12),
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        "Recommendations",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF764ba2),
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      viewModel.recommendation,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[800],
                                                        height: 1.5, // Better readability for paragraphs
                                                      ),
                                                    ),
                                                  ] 
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                          : Container(
                                              key: ValueKey('empty'),
                                            ),
                                ),

                                SizedBox(height: 40),

                                // Action Buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: _ActionButton(
                                        icon: Icons.camera_alt,
                                        label: "Camera",
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF667eea),
                                            Color(0xFF764ba2),
                                          ],
                                        ),
                                        onTap: () => viewModel.pickImage(ImageSource.camera),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: _ActionButton(
                                        icon: Icons.photo_library,
                                        label: "Gallery",
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF764ba2),
                                            Color(0xFFF093FB),
                                          ],
                                        ),
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
          padding: EdgeInsets.symmetric(vertical: 20),
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
              Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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