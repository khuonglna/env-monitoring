import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/view/map_view_model.dart';
import '../../styles/color.dart';
import '../../utils/app_utils.dart';
import 'station_detail.dart';

class StationListPage extends StatefulWidget {
  const StationListPage({super.key});

  @override
  State<StationListPage> createState() => _StationListPageState();
}

class _StationListPageState extends State<StationListPage> {
  @override
  Widget build(BuildContext context) {
    final model = MapViewModel.instance;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Text(
                'Cập nhật lần cuối lúc: ${DateFormat('HH:mm:ss dd-MM-yyyy').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    (model.stationRecordMap[1]!.first.secondTillEpoch ?? 0) *
                        1000,
                  ).subtract(
                    const Duration(
                      hours: 7,
                    ),
                  ),
                )}',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppColor.darkSilver,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: model.stationList.length,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 8,
                ),
                itemBuilder: (context, index) {
                  final station = model.stationList[index];
                  return OpenContainer(
                    closedElevation: 4,
                    closedBuilder: (context, action) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            color: AppUtils.instance.getStationQualityColor(
                              stationSensorQuality: model.stationSensorQuality[
                                      station.stationId] ??
                                  0,
                            ),
                            child: Icon(
                              AppUtils.instance.getQualityIcon(
                                model.stationSensorQuality[station.stationId] ??
                                    0,
                              ),
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                '${station.name ?? ''}: ${station.address}',
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Switch.adaptive(
                            value: model.enableStationList.contains(station),
                            onChanged: (value) {
                              setState(
                                () {
                                  if (value) {
                                    model.enableStationList.add(station);
                                  } else {
                                    model.enableStationList.remove(station);
                                  }
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    openBuilder: (context, action) => StationDetail(
                      stationId: station.stationId ?? 0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
