// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'map_ui.dart';
import 'page.dart';
import 'place_symbol.dart';

final List<ExamplePage> _allPages = <ExamplePage>[
  MapUiPage(),
  PlaceSymbolPage(),
];

class MapsDemo extends StatelessWidget {

  //FIXME: Add your Mapbox access token here
  static const String ACCESS_TOKEN = "pk.eyJ1IjoidGRvd2RsZSIsImEiOiJja2I4OG8waHgwMXQ0MnpwZ3llZzd0a3I2In0.es-ZqvN90XNR-pRpjdvQrw";

  void _pushPage(BuildContext context, ExamplePage page) async {
    if (!kIsWeb) {
      final location = Location();
      final hasPermissions = await location.hasPermission();
      if (hasPermissions != PermissionStatus.GRANTED) {
        await location.requestPermission();
      }
    }
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MapboxMaps examples')),
      body: ListView.builder(
        itemCount: _allPages.length,
        itemBuilder: (_, int index) => ListTile(
          leading: _allPages[index].leading,
          title: Text(_allPages[index].title),
          onTap: () => _pushPage(context, _allPages[index]),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: MapsDemo()));
}
