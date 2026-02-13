import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:typed_data';

/// Utility class to generate app icon
class IconGenerator {
  static Future<Uint8List> generateAppIcon({
    required Size size,
    Color backgroundColor = const Color(0xFF6366F1),
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    // Background gradient
    final gradient = ui.Gradient.linear(
      Offset.zero,
      Offset(size.width, size.height),
      [backgroundColor, backgroundColor.withValues(alpha: 0.7)],
    );
    
    paint.shader = gradient;
    
    // Draw rounded rectangle background
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(size.width * 0.2),
    );
    canvas.drawRRect(rrect, paint);

    // Draw wallet icon using path (simplified representation)
    paint.shader = null;
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    
    final iconSize = size.width * 0.5;
    final iconOffset = Offset(
      (size.width - iconSize) / 2,
      (size.height - iconSize) / 2,
    );
    
    // Simple wallet shape
    final walletPath = Path();
    walletPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          iconOffset.dx,
          iconOffset.dy,
          iconSize,
          iconSize * 0.7,
        ),
        Radius.circular(iconSize * 0.1),
      ),
    );
    canvas.drawPath(walletPath, paint);

    // Draw currency symbol
    final textPainter = TextPainter(
      text: TextSpan(
        text: '₹',
        style: TextStyle(
          color: backgroundColor,
          fontSize: size.width * 0.25,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    
    // Draw currency symbol on white circle
    final circlePaint = Paint()..color = Colors.white;
    final circleRadius = size.width * 0.15;
    final circleCenter = Offset(
      size.width * 0.7,
      size.height * 0.3,
    );
    
    canvas.drawCircle(circleCenter, circleRadius, circlePaint);
    
    textPainter.paint(
      canvas,
      Offset(
        circleCenter.dx - textPainter.width / 2,
        circleCenter.dy - textPainter.height / 2,
      ),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
