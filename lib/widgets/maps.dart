import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';

class MapsWidget extends StatefulWidget {
  MapsWidget({Key? key}) : super(key: key);

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(51.509364, -0.128928),
        zoom: 9.2,
      ),
      nonRotatedChildren: [
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
      ],
    );
  }

  /*LatLng getMapCenter() {
    double lat = 0, lng = 0;
    for (int i = 0; i < widget.coordinates.length; ++i) {
      lat += widget.coordinates[i].latitude;
      lng += widget.coordinates[i].longitude;
    }
    return LatLng(
        lat /= widget.coordinates.length, lng /= widget.coordinates.length);
  }

  double getMapZoom() {
    return 13; // TODO
  }*/
}
