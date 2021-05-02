part of 'custom_markers.dart';

class MarkerInicioPainter extends CustomPainter {
  final int minutos;

  MarkerInicioPainter(this.minutos);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()..color = Colors.black;

    final double circNegro = 20;
    final double circBlanco = 7;

    // Dibujar círculo negro
    canvas.drawCircle(
      Offset(circNegro, size.height - circNegro),
      20,
      paint,
    );

    // Círculo Blanco
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(circNegro, size.height - circNegro),
      circBlanco,
      paint,
    );

    // Sombra
    final Path path = new Path();
    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);

    canvas.drawShadow(path, Colors.black87, 10, true);

    // Caja Blanca
    final cajaBlanca = Rect.fromLTWH(40, 20, size.width - 55, 80);
    canvas.drawRect(cajaBlanca, paint);

    // Caja Negra
    paint.color = Colors.black;
    final cajaNegra = Rect.fromLTWH(40, 20, 70, 80);
    canvas.drawRect(cajaNegra, paint);

    // Dibujar texto
    TextSpan textSpan = new TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),
      text: '$minutos',
    );

    // Posición del texto en la caja negra
    TextPainter textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(40, 30));

    // Minutos
    textSpan = new TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
      text: 'min',
    );

    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(40, 60));

    // Mi ubicación
    textSpan = new TextSpan(
      style: TextStyle(
          color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
      text: 'Mi ubicación',
    );

    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: size.width - 130);

    textPainter.paint(canvas, Offset(150, 50));
  }

  @override
  bool shouldRepaint(MarkerInicioPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(MarkerInicioPainter oldDelegate) => false;
}
