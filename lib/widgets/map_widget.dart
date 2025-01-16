import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    super.key,
    this.onMapCreated,
    this.initialLong = 0,
    this.initialLat = 0,
    this.address,
  });
  final ValueSetter<MapController>? onMapCreated;
  final double initialLong;
  final double initialLat;
  final ValueSetter<String>? address;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late MapController _controller;
  final List<GeoPoint> _geoPoints = [];

  @override
  void initState() {
    _controller = MapController(
      useExternalTracking: false,
      initMapWithUserPosition: UserTrackingOption(
        unFollowUser: true,
        enableTracking: false,
      ),
      // initPosition: GeoPoint(
      //   latitude: widget.initialLat,
      //   longitude: widget.initialLong,
      // ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: _controller,
      onLocationChanged: (point) {
        _geoPoints.add(point);
      },
      osmOption: OSMOption(
        showZoomController: true,
        showDefaultInfoWindow: true,
        isPicker: true,
      ),
      onMapIsReady: (isReady) {
        _controller.setZoom(stepZoom: 40);

        if (isReady) {
          widget.onMapCreated?.call(_controller);
        }
      },
    );
  }
}
