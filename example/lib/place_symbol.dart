// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'main.dart';
import 'page.dart';

class PlaceSymbolPage extends ExamplePage {
  PlaceSymbolPage() : super(const Icon(Icons.place), 'Place symbol');

  @override
  Widget build(BuildContext context) {
    return const PlaceSymbolBody();
  }
}

class PlaceSymbolBody extends StatefulWidget {
  const PlaceSymbolBody();

  @override
  State<StatefulWidget> createState() => PlaceSymbolBodyState();
}

class PlaceSymbolBodyState extends State<PlaceSymbolBody> {
  PlaceSymbolBodyState();

  static final LatLng center = const LatLng(40.759, -111.876);

  MapboxMapController controller;
  int _symbolCount = 0;
  Symbol _selectedSymbol;
  bool _iconAllowOverlap = false;
  bool hasMapClicked = false;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onSymbolTapped.add(_onSymbolTapped);
  }

  void _onMapClick(Point<double> point, LatLng info) {
    if(!hasMapClicked){
      print("map click");
      hasMapClicked = true;
      _add("assets/symbols/map-marker.png");
    }
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/symbols/custom-icon.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }

  @override
  void dispose() {
    controller?.onSymbolTapped?.remove(_onSymbolTapped);
    super.dispose();
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await get(url);
    return controller.addImage(name, response.bodyBytes);
  }

  void _onSymbolTapped(Symbol symbol) {
    if (_selectedSymbol != null) {
      _updateSelectedSymbol(
        const SymbolOptions(iconSize: 1.0),
      );
    }
    setState(() {
      _selectedSymbol = symbol;
    });
    _updateSelectedSymbol(
      SymbolOptions(
        iconSize: 1.4,
      ),
    );
  }

  void _updateSelectedSymbol(SymbolOptions changes) {
    controller.updateSymbol(_selectedSymbol, changes);
  }

  void _add(String iconImage) {
    controller.setSymbolIconAllowOverlap(true);
    List<int> availableNumbers = Iterable<int>.generate(2362*5).toList();

    final List<SymbolOptions> symbolOptionsList = availableNumbers.map(
      (i) => _getSymbolOptions(iconImage, (i/2).toDouble())
    ).toList();

    controller.addSymbols(
      symbolOptionsList
    );
  
  }

  SymbolOptions _getSymbolOptions(String iconImage, double symbolCount){
    print((symbolCount/12).floor());
    int offset = (symbolCount/12).floor();
    return SymbolOptions(
      geometry: LatLng(
        40.758701 + sin(symbolCount * pi / 6.0) / (120.0-offset),
        -111.876183 + cos(symbolCount * pi / 6.0) / (120.0-offset),
      ),
      iconImage: iconImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 400.0,
            height: 796.0,
            child: MapboxMap(
              onMapClick: _onMapClick,
              accessToken: MapsDemo.ACCESS_TOKEN,
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoaded,
              initialCameraPosition: const CameraPosition(
                target: LatLng(40.758701, -111.876183),
                zoom: 11.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
