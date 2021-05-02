import 'package:flutter/material.dart';
import 'package:mapas_app/custom_markers/custom_markers.dart';

class TestMarkerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          height: 300,
          color: Colors.red,
          child: CustomPaint(
            // painter: MarkerInicioPainter(55),
            painter: MarkerDestinoPainter(
              'En esta posible ubicación ubicación ubicación se encuentra mi casa, donde inicia el viaje',
              125000,
            ),
          ),
        ),
      ),
    );
  }
}
