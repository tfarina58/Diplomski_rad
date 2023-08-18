import 'package:diplomski_rad/interfaces/user/user.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:diplomski_rad/interfaces/estate/estate.dart';
import 'package:diplomski_rad/estates/estate-details/estate-details.dart';
import 'dart:math';

class MapsWidget extends StatefulWidget {
  User user = Individual.getUser1();
  List<Estate> estates = [
    IndividualEstate.getEstate1(),
    IndividualEstate.getEstate2(),
    IndividualEstate.getEstate3(),
  ];

  MapsWidget({Key? key}) : super(key: key);

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  @override
  Widget build(BuildContext context) {
    LatLng mapCenter = getMapCenter();
    double zoom = getMapZoom(mapCenter);

    return FlutterMap(
      options: MapOptions(
        center: mapCenter,
        zoom: zoom,
        maxZoom: 17,
        minZoom: 1.7,
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
        MarkerLayer(
          markers: getMarkerLayer(),
        ),
      ],
    );
  }

  LatLng getMapCenter() {
    if (widget.estates.isEmpty) return const LatLng(0, 0);

    double lat = 0, lng = 0;
    for (int i = 0; i < widget.estates.length; ++i) {
      if (widget.estates[i].coordinates != null) {
        lat += widget.estates[i].coordinates!.latitude;
        lng += widget.estates[i].coordinates!.longitude;
      }
    }
    return LatLng(lat /= widget.estates.length, lng /= widget.estates.length);
  }

  double getMapZoom(LatLng center) {
    /*double maxDistance = 0, tmpDistance;
    for (int i = 0; i < widget.estates.length; ++i) {
      if (widget.estates[i].coordinates != null) {
        tmpDistance = distance(
            center.latitude,
            center.longitude,
            widget.estates[i].coordinates!.latitude,
            widget.estates[i].coordinates!.longitude);

        print(tmpDistance);

        if (tmpDistance > maxDistance) {
          maxDistance = tmpDistance;
        }
      }
    }
    double zoom = log(maxDistance) / log(0.1492919921875);
    print(zoom);*/
    return 8;
  }

  double distance(double lat1, double long1, double lat2, double long2) {
    lat1 = (pi) / 180 * lat1;
    long1 = (pi) / 180 * long1;
    lat2 = (pi) / 180 * lat2;
    long2 = (pi) / 180 * long2;

    // Haversine Formula
    double dlong = long2 - long1;
    double dlat = lat2 - lat1;

    double ans =
        pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlong / 2), 2);

    ans = 2 * asin(sqrt(ans));

    // Radius of Earth in
    // Kilometers, R = 6371
    // Use R = 3956 for miles
    double R = 6371;

    ans = ans * R;

    return ans;
  }

  List<Marker> getMarkerLayer() {
    List<Marker> markerList = [];
    for (int i = 0; i < widget.estates.length; ++i) {
      if (widget.estates[i].coordinates == null) continue;
      markerList.add(
        Marker(
          point: LatLng(
            widget.estates[i].coordinates!.latitude,
            widget.estates[i].coordinates!.longitude,
          ),
          builder: (context) => MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EstateDetailsPage(estate: widget.estates[i]),
                ),
              ),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: PalleteCommon.backgroundColor),
                child: const Center(
                  child: Icon(
                    Icons.house,
                    color: PalleteCommon.gradient3,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return markerList;
  }
}
