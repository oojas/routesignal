import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'dart:developer';
import 'package:wifi/wifi.dart';

class pings extends StatefulWidget {
  @override
  _pingsState createState() => _pingsState();
}

class _pingsState extends State<pings> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var time = Timer;
  @override
  void cal() async {
    final String ip = await Wifi.ip;
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    final int port = 80;
    int found = 0;

    final stream = NetworkAnalyzer.discover2(
      subnet,
      port,
    );
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        found++;
        print('Found device: ${addr.ip}');

        print(found);
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            final stopwatch = Stopwatch()..start();

            cal();

            print('cal() executed in ${stopwatch.elapsed.inMilliseconds}');
          },
          child: Text('Ping'),
        ),
      ),
    );
  }
}
