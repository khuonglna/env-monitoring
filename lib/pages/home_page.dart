import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(13.4439, 109.249),
          zoom: 13,
        ),
        // nonRotatedChildren: [
        //   AttributionWidget.defaultWidget(
        //     source: 'OpenStreetMap contributors',
        //     onSourceTapped: null,
        //   ),
        // ],
        children: [
          TileLayer(
            urlTemplate: 'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
            // maxZoom: 8,
            // tileSize: 260 ,
            retinaMode: true,
            // userAgentPackageName: 'com.example.app',
            subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(13.4487, 109.257),
                width: 40,
                height: 40,
                builder: (context) => const FlutterLogo(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
