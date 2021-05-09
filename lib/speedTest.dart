import 'package:flutter/material.dart';
import 'package:internet_speed_test/internet_speed_test.dart';
import 'package:internet_speed_test/callbacks_enum.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:wifi/wifi.dart';

// ignore: camel_case_types
class speed extends StatefulWidget {
  @override
  _speedState createState() => _speedState();
}

DateTime pre = new DateTime.now();
void time() {
  print('Current Time : ${pre.hour}: ${pre.minute}:${pre.second}');
}

// ignore: camel_case_types
class _speedState extends State<speed> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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

  int latency = 0;

  final internetSpeedTest = InternetSpeedTest();

  double downloadRate = 0;
  double uploadRate = 0;
  String downloadProgress = '0';
  String uploadProgress = '0';

  String unitText = 'Mb/s';

  Position val;

  Future<Position> _getcurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    Position loc = await Geolocator.getCurrentPosition();
    setState(() {
      val = loc;
    });

    return loc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.purple.shade100,
                elevation: 5,
                onPressed: () {
                  internetSpeedTest.startDownloadTesting(
                    onDone: (double transferRate, SpeedUnit unit) {
                      print('the transfer rate $transferRate');
                      setState(() {
                        downloadRate = transferRate;
                        unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                        downloadProgress = '100';
                      });
                    },
                    onProgress:
                        (double percent, double transferRate, SpeedUnit unit) {
                      print(
                          'the transfer rate $transferRate, the percent $percent');
                      setState(() {
                        downloadRate = transferRate;
                        unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                        downloadProgress = percent.toStringAsFixed(2);
                      });
                    },
                    onError: (String errorMessage, String speedTestError) {
                      print(
                          'the errorMessage $errorMessage, the speedTestError $speedTestError');
                    },
                    testServer: 'http://ipv4.ikoula.testdebit.info/1M.iso',
                    fileSize: 20000000,
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(15)),
                child: SizedBox(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.download_outlined,
                          size: 35,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Test your download speed',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 15,
                  color: Colors.deepPurple[200],
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Progress $downloadProgress%',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 15,
                  color: Colors.deepPurple[200],
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Download rate  $downloadRate $unitText',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.purple.shade100,
                elevation: 7,
                onPressed: () {
                  internetSpeedTest.startUploadTesting(
                    onDone: (double transferRate, SpeedUnit unit) {
                      print('the transfer rate $transferRate');
                      setState(() {
                        uploadRate = transferRate;
                        unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                        uploadProgress = '100';
                      });
                    },
                    onProgress:
                        (double percent, double transferRate, SpeedUnit unit) {
                      print(
                          'the transfer rate $transferRate, the percent $percent');
                      setState(() {
                        uploadRate = transferRate;
                        unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                        uploadProgress = percent.toStringAsFixed(2);
                      });
                    },
                    onError: (String errorMessage, String speedTestError) {
                      print(
                          'the errorMessage $errorMessage, the speedTestError $speedTestError');
                    },
                    testServer: 'http://ipv4.ikoula.testdebit.info/',
                    fileSize: 20000000,
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(15)),
                child: SizedBox(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.upload_outlined,
                          size: 35,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Test your upload speed',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 15,
                  color: Colors.deepPurple[200],
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Progress $uploadProgress%',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 15,
                  color: Colors.deepPurple[200],
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Upload rate  $uploadRate $unitText',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                elevation: 15,
                onPressed: () async {
                  var value = await _getcurrentLocation();

                  print(value);
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Your Location',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                color: Colors.purple.shade100,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.deepPurple[200],
                    elevation: 15,
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          '${val}',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 15,
                color: Colors.purple.shade100,
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Current Time : ${pre.hour}: ${pre.minute}: ${pre.second}',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                elevation: 5,
                onPressed: () {
                  final stopwatch = Stopwatch()..start();

                  cal();
                  int val = stopwatch.elapsed.inMilliseconds;
                  print('cal() executed in ${val}');
                  setState(() {
                    latency = val;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Check your Wfi ping',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                color: Colors.purple.shade100,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.deepPurple[200],
              elevation: 15,
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    '${latency} milliseconds,',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
