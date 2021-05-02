import 'dart:async';
import 'dart:convert';

import 'package:mapas_app/helpers/helpers.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors, Offset;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/themes/uber_map_theme.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(MapaState());

  // Controlador de Mapa
  GoogleMapController _mapController;

  // Polylines
  Polyline _miRuta = new Polyline(
    polylineId: PolylineId('mi_ruta'),
    width: 4,
    color: Colors.transparent,
  );

  Polyline _miRutaDestino = new Polyline(
    polylineId: PolylineId('mi_ruta_destino'),
    width: 4,
    color: Colors.black87,
  );

  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      this._mapController = controller;
      this._mapController.setMapStyle(jsonEncode(uberMapTheme));

      add(OnMapaListo());
    }
  }

  void moverCamara(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(MapaEvent event) async* {
    if (event is OnMapaListo) {
      yield state.copyWith(mapaListo: true);
    } else if (event is OnNuevaUbicacion) {
      yield* this._onNuevaUbicacion(event);
    } else if (event is OnMarcarRecorrido) {
      yield* this._onMarcarRecorrido(event);
    } else if (event is OnSeguirUbicacion) {
      yield* this._onSeguirUbicacion(event);
    } else if (event is OnMovioMapa) {
      yield state.copyWith(ubicacionCentral: event.centroMapa);
    } else if (event is OnCrearRutaInicioDestino) {
      yield* this._onCrearRutaInicioDestino(event);
    }
  }

  Stream<MapaState> _onNuevaUbicacion(OnNuevaUbicacion event) async* {
    if (state.seguirUbicacion) {
      this.moverCamara(event.ubicacion);
    }
    final points = [...this._miRuta.points, event.ubicacion];
    this._miRuta = this._miRuta.copyWith(pointsParam: points);

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = this._miRuta;

    yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapaState> _onMarcarRecorrido(OnMarcarRecorrido event) async* {
    if (!state.dibujarRecorrido) {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.black87);
    } else {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.transparent);

      final currentPolylines = state.polylines;
      currentPolylines['mi_ruta'] = this._miRuta;

      yield state.copyWith(
        dibujarRecorrido: !state.dibujarRecorrido,
        polylines: currentPolylines,
      );
    }
  }

  Stream<MapaState> _onSeguirUbicacion(OnSeguirUbicacion event) async* {
    if (!state.seguirUbicacion) {
      this.moverCamara(this._miRuta.points[this._miRuta.points.length - 1]);
    }
    yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
  }

  Stream<MapaState> _onCrearRutaInicioDestino(
      OnCrearRutaInicioDestino event) async* {
    this._miRutaDestino =
        this._miRutaDestino.copyWith(pointsParam: event.rutaCoordenadas);

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta_destino'] = this._miRutaDestino;

    // Icono inicio
    // Marcador asset
    // final iconInicio = await getAssetImageMarker();

    // Marcador personalizado
    final iconInicio = await getMarkerInicioIcon(event.duracion.toInt());

    // Marcador NetworkImage
    // final iconDestino = await getNetworkImageMarker();

    // Marcador personalizado
    final iconDestino =
        await getMarkerDestinoIcon(event.nombreDestino, event.distancia);

    // Marcadores
    // Marcador inicio
    final markerInicio = new Marker(
        markerId: MarkerId('inicio'),
        anchor: Offset(0.1, 0.9),
        position: event.rutaCoordenadas[0],
        icon: iconInicio,
        infoWindow: InfoWindow(
          title: 'Inicio de ruta',
          // snippet: 'Descripción de el lugar del recorrido ejemplo'
          snippet:
              'Duración de recorrido: ${(event.duracion / 60).floor()} minutos',
        ));
    double kilometros = event.distancia / 1000;
    kilometros = (kilometros * 100).floorToDouble();
    kilometros = kilometros / 100;

    // Marcador destino
    final markerDestino = new Marker(
      markerId: MarkerId('destino'),
      anchor: Offset(0.1, 0.9),
      position: event.rutaCoordenadas[event.rutaCoordenadas.length - 1],
      icon: iconDestino,
      // infoWindow: InfoWindow(
      // title: event.nombreDestino,
      // snippet: 'Distancia de recorrido: $kilometros km'),
    );

    final newMarkers = {...state.markers};
    newMarkers['inicio'] = markerInicio;
    newMarkers['destino'] = markerDestino;

    Future.delayed(Duration(milliseconds: 300)).then(
        (value) => _mapController.showMarkerInfoWindow(MarkerId('destino')));

    yield state.copyWith(
      polylines: currentPolylines,
      markers: newMarkers,
    );
  }
}
