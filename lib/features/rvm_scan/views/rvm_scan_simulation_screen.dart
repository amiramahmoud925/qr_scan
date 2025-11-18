import 'package:flutter/material.dart';
import '../models/rvm_model.dart';
import 'rvm_confirm_screen.dart';

class RvmScanSimulationScreen extends StatefulWidget {
  const RvmScanSimulationScreen({super.key});

  @override
  State<RvmScanSimulationScreen> createState() => _RvmScanSimulationScreenState();
}

class _RvmScanSimulationScreenState extends State<RvmScanSimulationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _simulateScan(BuildContext context) async {
    _showScanningOverlay();
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pop();

      final rvm = RvmModel(
        id: 'RVM-CAIRO-001',
        name: 'Downtown Cairo RVM',
        welcome: 'Welcome eco-warrior! Ready to make a difference?',
        location: 'Orman Street, Downtown Cairo',
        status: 'Available',
        rating: 4.8,
        distance: 150,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RvmConfirmScreen(rvmData: rvm),
        ),
      );
    }
  }

  void _showScanningOverlay() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      barrierDismissible: false,
      builder: (context) => const ScanAnimationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('QR Scanner', style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF666666)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFF0F9F0),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    margin:  EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color:  Color(0xFF4CAF50).withOpacity(_animation.value),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:  Color(0xFF4CAF50).withOpacity(0.2),
                          blurRadius: 20, spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                        child: Stack(
                          children: [
                            Positioned(
                              top: (MediaQuery.of(context).size.height * 0.4 - 80) * _animation.value,
                              left: 20,
                              right: 20,
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xFF4CAF50),
                                      Colors.transparent,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF4CAF50).withOpacity(0.8),
                                      blurRadius: 10, spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Corner decorations
                            _buildCorner( Alignment.topLeft),
                            _buildCorner( Alignment.topRight),
                            _buildCorner( Alignment.bottomLeft),
                            _buildCorner( Alignment.bottomRight),

                            // Center QR icon
                            const Center(
                              child: Icon(Icons.qr_code_2, size: 80, color: Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  Text('Position QR code within frame',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                   SizedBox(height: 8),
                  Text('Align the QR code on the RVM with the frame above',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF4CAF50).withOpacity(0.3),
                          blurRadius: 15,
                          offset:  Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      icon:  Icon(Icons.qr_code_scanner, size: 24),
                      label:  Text('Simulate QR Scan', style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => _simulateScan(context),
                    ),
                  ),

                   SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
                    child: Text('Enter RVM ID manually',
                      style: TextStyle(
                        color: const Color(0xFF4CAF50),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            left: BorderSide(
              color: const Color(0xFF4CAF50),
              width: alignment == Alignment.topLeft || alignment == Alignment.bottomLeft ? 3 : 0,
            ),
            top: BorderSide(
              color: const Color(0xFF4CAF50),
              width: alignment == Alignment.topLeft || alignment == Alignment.topRight ? 3 : 0,
            ),
            right: BorderSide(
              color: const Color(0xFF4CAF50),
              width: alignment == Alignment.topRight || alignment == Alignment.bottomRight ? 3 : 0,
            ),
            bottom: BorderSide(
              color: const Color(0xFF4CAF50),
              width: alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight ? 3 : 0,
            ),
          ),
        ),
      ),
    );
  }
}

class ScanAnimationDialog extends StatelessWidget {
  const ScanAnimationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: 40, height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),
            Text('Scanning QR Code...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A),
              ),
            ),

             SizedBox(height: 16),
            Text('Please hold your device steady',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}