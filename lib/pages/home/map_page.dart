import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/base_bloc.dart';
import '../../bloc/map/map_bloc.dart';
import '../../constants/app_constant.dart';
import '../../constants/constant.dart';
import '../../dependencies.dart';
import '../../models/view/map_view_model.dart';
import '../../utils/app_utils.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final MapBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = AppDependencies.injector.get<MapBloc>();
    bloc.init();
  }

  @override
  void dispose() {
    bloc.clearTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocConsumer(
      bloc: bloc,
      listener: (context, state) {
        if (state is LoadedState) {
          if (state.isShowLoading) {
            showCupertinoDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) => const CircularProgressIndicator.adaptive(),
            );
            return;
          } else if (state.errorMessage?.isNotEmpty ?? false) {
            bloc.clearTimer();
            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                actions: [
                  TextButton(
                    onPressed: () => context.go(
                      AppPath.login,
                    ),
                    child: const Text('OK'),
                  ),
                ],
                title: const Text('Error'),
                content: Text(state.errorMessage ?? ''),
              ),
            );
            return;
          } else {
            if (context.canPop()) {
              context.pop();
            }
          }
        }
      },
      builder: (context, state) {
        if (state is LoadedState) {
          if (state.isShowLoading) {
            return const SizedBox.shrink();
          } else {
            final MapViewModel model = state.model;
            return Scaffold(
              floatingActionButton: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: OpenContainer(
                    closedColor: Colors.transparent,
                    closedElevation: 0,
                    closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    closedBuilder: (context, action) => ElevatedButton(
                      onPressed: action,
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          colorScheme.surface,
                        ),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        shadowColor: MaterialStatePropertyAll(
                          colorScheme.shadow,
                        ),
                        elevation: const MaterialStatePropertyAll(5),
                      ),
                      child: Text(
                        '${model.selectedSensor?.name ?? '--'}  ${model.selectedSensor?.unitSymbol != null ? (model.selectedSensor?.unitSymbol) : ''}',
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                    ),
                    transitionType: ContainerTransitionType.fadeThrough,
                    openBuilder: (context, action) => Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        iconTheme: IconThemeData(
                          color: colorScheme.onSurface,
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.info_outline,
                            ),
                          )
                        ],
                      ),
                      body: GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 3 / 2,
                        ),
                        itemCount: model.sensorList.length,
                        itemBuilder: (context, index) {
                          final sensor = model.sensorList[index];
                          return ElevatedButton(
                            onPressed: () {
                              bloc.selectSensor(sensor);
                              action.call();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                colorScheme.surface,
                              ),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              shadowColor: MaterialStatePropertyAll(
                                colorScheme.shadow,
                              ),
                              elevation: const MaterialStatePropertyAll(5),
                            ),
                            child: Text(
                              sensor.name ?? '--',
                              style: TextStyle(color: colorScheme.onSurface),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Container(
              //   padding: const EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     color: theme.colorScheme.surface,
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Text(
              //     model.selectedSensor?.name ?? '--',
              //   ),
              // ),
              body: FlutterMap(
                options: MapOptions(
                  center: model.focusLatLng,
                  zoom: 13.42,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    // urlTemplate:
                    //     'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                    retinaMode: true,
                    subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                    fallbackUrl:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: model.enableStationList
                        .map(
                          (station) => Marker(
                            point: station.latLng ?? AppConstant.defaultLatLng,
                            width: 64,
                            height: 64,
                            builder: (context) => Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 10,
                                  color:
                                      AppUtils.instance.getStationQualityColor(
                                    stationSensorQuality: model
                                            .stationRecordMap[station.stationId]
                                            ?.first
                                            .stationSQI ??
                                        0,
                                  ),
                                ),
                                color: colorScheme.surface,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                bloc.getSensorValueByStation(
                                  station.stationId ?? 0,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                ],
              ),
            );
          }
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
