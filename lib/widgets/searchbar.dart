part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(Object context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return Container();
        } else {
          return FadeInDown(
            duration: Duration(milliseconds: 350),
            child: buildSearchBar(context),
          );
        }
      },
    );
  }

  Widget buildSearchBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: width,
        child: GestureDetector(
          onTap: () async {
            final proximidad =
                BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
            final historial =
                BlocProvider.of<BusquedaBloc>(context).state.historial;
            final resultado = await showSearch(
                context: context,
                delegate: BuscarDestino(proximidad, historial));
            this.retornoBusqueda(context, resultado);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: double.infinity,
            child: Text(
              '¿A dónde vamos?',
              style: TextStyle(color: Colors.black87),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  Future retornoBusqueda(BuildContext context, SearchResult result) async {
    if (result.cancelo) return;

    if (result.manual) {
      BlocProvider.of<BusquedaBloc>(context).add(OnActivarMarcadorManual());
      return;
    }

    calculandoAlerta(context);

    // Calcular la ruta en base al valor del resultado: Result
    final trafficService = new TrafficService();
    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    final inicio = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    final destino = result.position;

    final drivingResponse =
        await trafficService.getCoodsInicioYDestino(inicio, destino);

    final geometry = drivingResponse.routes[0].geometry;
    final duracion = drivingResponse.routes[0].duration;
    final distancia = drivingResponse.routes[0].distance;
    final nombreDestino = result.nombreDestino;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6);
    final List<LatLng> rutaCoordenadas = points.decodedCoords
        .map((point) => LatLng(point[0], point[1]))
        .toList();
    mapaBloc.add(OnCrearRutaInicioDestino(
        rutaCoordenadas, distancia, duracion, nombreDestino));

    Navigator.of(context).pop(context);

    // Agregar al historial
    final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
    busquedaBloc.add(OnAgregarHistorial(result));
  }
}
