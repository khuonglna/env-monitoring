import 'package:flutter/material.dart';

import '../../models/view/map_view_model.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final model = MapViewModel.instance;
    return Scaffold(
      body: Center(
        child: Text(model.stationList.first.name ?? '--'),
      ),
    );
  }
}
