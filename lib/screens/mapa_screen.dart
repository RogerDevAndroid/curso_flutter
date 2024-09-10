import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movies_app/api/api_service.dart';
import 'package:permission_handler/permission_handler.dart';

//void main() => runApp(const MyAppMap());

class MyAppMap extends StatefulWidget {
  const MyAppMap({Key? key}) : super(key: key);

  @override
  _MyAppMapState createState() => _MyAppMapState();
}

class _MyAppMapState extends State<MyAppMap> {
  late GoogleMapController mapController;
  final TextEditingController _searchController = TextEditingController();

  LatLng _center = LatLng(0.0, 0.0);
  Set<Marker> _markers = {};
  String _searchQuery = '';
  int _searchRadius = 1000; // Valor por defecto del radio de búsqueda
  final List<Map<String, dynamic>> _radiusOptions = [
    {'label': '500 metros', 'value': 500},
    {'label': '1 km', 'value': 1000},
    {'label': '3 km', 'value': 3000},
    {'label': '5 km', 'value': 5000},
    {'label': '10 km', 'value': 10000},
  ];

  Future<void> _getNearStore() async {
    _markers.clear();

    await _getCurrentLocation();

    if (_searchQuery != null && _searchQuery.isNotEmpty) {
      final googleTienditas = await ApiService.getSearchStore(
          _searchQuery, _center.latitude, _center.longitude, _searchRadius);

      setState(() {
        if (googleTienditas == null || googleTienditas.isEmpty) {
          _showNoResultsDialog();
        } else {
          for (final tienda in googleTienditas!) {
            final marker = Marker(
              markerId: MarkerId(tienda.nombre),
              position: LatLng(
                  double.parse(tienda.latitud), double.parse(tienda.longitud)),
              infoWindow: InfoWindow(
                title: tienda.nombre,
                snippet: tienda.ubicacion,
              ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen)
            );

            _markers.add(marker);
          }
        }
      });
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.status;

    if (status.isDenied) {
      final result = await Permission.location.request();
      if (result.isGranted) {
        _getNearStore();
      } else {
        print('Location permission denied');
      }
    } else if (status.isGranted) {
      _getNearStore();
    } else if(status.isRestricted){
      print('Ubicacion Denegada por Control Parental');
    }
    else {
      //PorDefault
    }
  }

  Future<void> _getCurrentLocation() async {
    try {

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _center = LatLng(position.latitude, position.longitude);

        _markers.add(Marker(
            markerId: const MarkerId('Mi ubicación'),
            position: _center,
            infoWindow: const InfoWindow(
              title: "Mi ubicación",
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue)));

        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
          ),
        );
      });
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _getNearStore();
  }

  void _showNoResultsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No se encontraron resultados',
              style: TextStyle(color: Colors.black)),
          content: const Text(
              'No se encontraron tiendas que coincidan con su búsqueda.',
              style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mapa de Tienditas',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green[700],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Buscar tiendas...',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed:
                              _onSearchChanged, // Llamar a _onSearchChanged cuando se hace clic en el ícono de búsqueda
                        ),
                      ),
                      onSubmitted: (_) =>
                          _onSearchChanged(), // Llamar a _onSearchChanged cuando se presiona "Enter" o "Done"
                    ),
                  ),
                  SizedBox(width: 8.0),
                  // Espacio entre el campo de texto y el dropdown
                  DropdownButton<int>(
                    value: _searchRadius,
                    onChanged: (int? newValue) {
                      setState(() {
                        _searchRadius = newValue!;
                      });
                      _getNearStore(); // Actualizar la búsqueda cuando cambia el radio
                    },
                    items: _radiusOptions.map<DropdownMenuItem<int>>((option) {
                      return DropdownMenuItem<int>(
                        value: option['value'],
                        child: Text(option['label']),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                markers: _markers,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
