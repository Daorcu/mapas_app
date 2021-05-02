part of 'custom_markers.dart';

class MarkerDestinoPainter extends CustomPainter {
  final String descripcion;
  final double metros;

  MarkerDestinoPainter(this.descripcion, this.metros);

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
    path.moveTo(0, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(0, 100);

    canvas.drawShadow(path, Colors.black87, 10, true);

    // Caja Blanca
    final cajaBlanca = Rect.fromLTWH(0, 20, size.width - 10, 80);
    canvas.drawRect(cajaBlanca, paint);

    // Caja Negra
    paint.color = Colors.black;
    final cajaNegra = Rect.fromLTWH(0, 20, 70, 80);
    canvas.drawRect(cajaNegra, paint);

    // Dibujar texto
    double kilometros = this.metros / 1000;
    kilometros = (kilometros * 100).floorToDouble();
    kilometros = kilometros / 100;

    TextSpan textSpan = new TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
      text: '$kilometros',
    );

    // Posición del texto en la caja negra
    TextPainter textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 80, minWidth: 65);

    textPainter.paint(canvas, Offset(2, 30));

    // Kilómetros
    textSpan = new TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
      text: 'Km',
    );

    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70);

    textPainter.paint(canvas, Offset(20, 60));

    // Mi ubicación
    textSpan = new TextSpan(
      style: TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
      text: this.descripcion,
    );

    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        maxLines: 3,
        ellipsis: '...')
      ..layout(maxWidth: size.width - 85);

    textPainter.paint(canvas, Offset(80, 25));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
