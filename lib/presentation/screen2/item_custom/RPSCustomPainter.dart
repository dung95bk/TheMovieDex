import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:themoviedex/presentation/util/hex_color.dart';

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint_0 = new Paint()
      ..color = HexColor("#C1C1C1")
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;


    Path path_0 = Path();
    path_0.moveTo(0,0);
    path_0.lineTo(size.width*0.7631579,0);
    path_0.quadraticBezierTo(size.width*0.7751579,size.height*0.1002000,size.width*0.7894737,size.height*0.1000000);
    path_0.quadraticBezierTo(size.width*0.8040000,size.height*0.0986000,size.width*0.8157895,0);
    path_0.lineTo(size.width,0);
    path_0.lineTo(size.width,size.height);
    path_0.lineTo(size.width,size.height);
    path_0.lineTo(size.width*0.8157895,size.height);
    path_0.quadraticBezierTo(size.width*0.8056579,size.height*0.9013000,size.width*0.7894737,size.height*0.9000000);
    path_0.quadraticBezierTo(size.width*0.7731053,size.height*0.8976000,size.width*0.7631579,size.height);
    path_0.lineTo(0,size.height);
    path_0.lineTo(0,0);
    path_0.close();

    canvas.drawPath(path_0, paint_0);

    Paint paint_2 = new Paint()
      ..color = HexColor("#000000")
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;


    double dashHeight = 5, dashSpace = 3, startY = size.height*0.15, endY = size.height*0.85, fixedX = size.width*0.7894737;
    final paint = Paint()
      ..color = Colors.grey[300]
      ..strokeWidth = 1;
    while (startY < endY) {
      canvas.drawLine(Offset(fixedX, startY), Offset(fixedX, startY + dashHeight), paint_2);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
