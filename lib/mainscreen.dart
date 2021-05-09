import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:routeSignal/ConnectivityCheck.dart';
import 'package:routeSignal/WifiList.dart';
import 'package:routeSignal/main.dart';
import 'package:routeSignal/speedTest.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[500],
          centerTitle: true,
          title: Text(
            'Route Signal',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('Basic Parameters'),
              ),
              Tab(
                child: Text('Detailed Parameters'),
              ),
              Tab(
                child: Text('Wifi/Cellular'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [speed(), Wifilist(), netCheck()],
        ),
      ),
    );
  }
}
