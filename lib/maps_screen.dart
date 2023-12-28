import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:maps/api.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List listOfPoints = [];
  List<LatLng> points = [];

// Función para consumir API de OpenRuoteService
  getCoordinates() async {
    var response = await http.get(getRouteUrl(
        "-76.60275504232936,2.4423734054452355",
        "-76.59917161135567,2.4438419199231767"));

    setState(() {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        listOfPoints = data['features'][0]['geometry']['coordinates'];
        points = listOfPoints
            .map((e) => LatLng(e[1].toDouble(), e[0].toDouble()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: const MapOptions(
            initialZoom: 13,
            initialCenter: LatLng(2.4423734054452355, -76.60275504232936)),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          MarkerLayer(
            markers: [
              //First marker
              Marker(
                point: const LatLng(2.4423734054452355, -76.60275504232936),
                width: 80,
                height: 80,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.location_on),
                  color: Colors.cyanAccent,
                  iconSize: 45,
                ),
              ),
              //Second marker
              Marker(
                point: const LatLng(2.4438419199231767, -76.59917161135567),
                width: 80,
                height: 80,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.location_on),
                  color: const Color.fromARGB(255, 24, 255, 70),
                  iconSize: 45,
                ),
              ),
            ],
          ),

          //Polyline layer para marcar la ruta
          PolylineLayer(
            polylineCulling: false,
            polylines: [
              Polyline(points: points, color: Colors.black87, strokeWidth: 5),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getCoordinates();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  // jsonDecode(String body) {}
}
