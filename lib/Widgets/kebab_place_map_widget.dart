import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class KebabPlaceMapWidget extends StatefulWidget {
  const KebabPlaceMapWidget({super.key});

  @override
  State<KebabPlaceMapWidget> createState() => _KebabPlaceMapWidgetState();
}

class _KebabPlaceMapWidgetState extends State<KebabPlaceMapWidget> {
  final LatLng _initialPosition = const LatLng(51.2070, 16.1550);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: _initialPosition,
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          retinaMode: RetinaMode.isHighDensity(context),
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
      ],
    );
  }
}
