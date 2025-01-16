import 'package:detrack/blocs/blocs.dart';
import 'package:detrack/core/core.dart';
import 'package:detrack/models/models.dart';
import 'package:detrack/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:intl/intl.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key, required this.title});
  final String title;
  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late final LocationBloc _bloc;
  MapController? _controller;
  int _selectedValue = 5;

  @override
  void initState() {
    _bloc = context.read<LocationBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BlocConsumer<LocationBloc, LocationBlocState>(
              listenWhen: (prev, current) {
                return prev.locationInfo != current.locationInfo;
              },
              listener: (context, state) async {
                if (state.status == BlocStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message ?? 'An error occured'),
                    ),
                  );
                }

                if (_controller != null) {
                  final long = state.locationInfo?.long ?? 0;
                  final lat = state.locationInfo?.lat ?? 0;
                  await _controller?.moveTo(
                    GeoPoint(
                      latitude: lat,
                      longitude: long,
                    ),
                    animate: true,
                  );

                  final geoPoints = await _controller?.geopoints;

                  await _controller?.removeMarkers(geoPoints ?? []);

                  await _controller?.addMarker(
                    GeoPoint(
                      latitude: lat,
                      longitude: long,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 1.5,
                            child:
                                _buildDropdownLocationList(state.oldLocations)),
                        SizedBox(
                          height: 24,
                        ),
                        if (state.locationInfo != null &&
                            state.streamStatus.isActive)
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width,
                            child: MapWidget(
                              initialLat: state.locationInfo?.lat ?? 0,
                              initialLong: state.locationInfo?.long ?? 0,
                              onMapCreated: (value) => _controller = value,
                            ),
                          ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                            'Location stream status: ${state.streamStatus.isActive}'),
                        SizedBox(
                          height: 12,
                        ),
                        if (state.streamStatus.isActive &&
                            state.locationInfo != null) ...[
                          Text(
                            'Address: ${state.locationInfo?.address},',
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Latitude: ${state.locationInfo!.lat},',
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Longitude: ${state.locationInfo!.long}',
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Last Update: ${state.locationInfo!.date}',
                          ),
                        ],
                        ElevatedButton(
                          onPressed: () {
                            if (state.streamStatus.isActive) {
                              _bloc.add(LocationBlocStopLocationStreamEvent());
                            } else {
                              _bloc.add(LocationBlocStartLocationStreamEvent());
                            }
                          },
                          child: Text(
                            state.streamStatus.isActive
                                ? 'Stop location stream'
                                : 'Start location stream',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (state.streamStatus.isActive) {
                              _bloc
                                  .add(LocationBlocStopPeriodicLocationEvent());
                            } else {
                              _bloc.add(
                                  LocationBlocStartPeriodicLocationEvent());
                            }
                          },
                          child: Text(
                            state.streamStatus.isActive
                                ? 'Stop periodic location stream ( every 5 secs)'
                                : 'Start periodiclocation stream ( every 5 secs)',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownLocationList(List<LocationInfo> locations) {
    final items = const [
      DropdownMenuItem(value: 5, child: Text('Last 5 readings')),
      DropdownMenuItem(value: 10, child: Text('Last 10 readings')),
      DropdownMenuItem(value: 15, child: Text('Last 15 readings')),
      DropdownMenuItem(value: 20, child: Text('Last 20 readings')),
    ];

    final cleanList = locations.nonNulls.toList();

    if (locations.isEmpty) {
      return const SizedBox();
    }

    final filteredItems = items.where((item) {
      return item.value! <= cleanList.length;
    }).toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
            items: filteredItems,
            value: _selectedValue,
            onChanged: (v) {
              setState(() {
                if (v == null) return;
                _selectedValue = v;
              });
              showDialog(
                  context: context,
                  builder: (c) {
                    return Dialog(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Last $v readings',
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Scrollbar(
                                thumbVisibility: true,
                                trackVisibility: true,
                                child: Flexible(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: v,
                                    itemBuilder: (context, index) {
                                      final loc = cleanList[index];
                                      return ListTile(
                                        leading: Icon(Icons.location_on),
                                        title: Text(loc.address ?? 'Unknown'),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('${loc.lat}, ${loc.long}'),
                                            Text(DateFormat(
                                                    'dd/MM/yyyy hh:mm aa')
                                                .format(loc.date)),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
