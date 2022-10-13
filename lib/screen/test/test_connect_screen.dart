import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:oem_huahuan_1013/screen/test/test_measure_screen.dart';
import 'package:oem_huahuan_1013/widget/common_widget/common_app_bar.dart';

class TestConnectScreen extends StatefulWidget {
  const TestConnectScreen({Key? key}) : super(key: key);

  @override
  State<TestConnectScreen> createState() => _TestConnectScreenState();
}

class _TestConnectScreenState extends State<TestConnectScreen> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> scanResults = [];
  bool isDiscovering = false;

  @override
  void initState() {
    super.initState();
    checkIfConnect();
    _onRefresh();
  }

  void checkIfConnect() async {
    await flutterBlue.connectedDevices.then(
      (list) => {
        if (list.isNotEmpty)
          {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => Test(
                  device: list[0],
                ),
              ),
            ),
          },
      },
    );
  }

  ///before
  Future<void> _onRefresh() async {
    flutterBlue.stopScan();
    if (kDebugMode) {
      print('开始扫描外设');
    }
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    flutterBlue.scanResults.listen((scanResult) {
      if (mounted) {
        setState(() {
          scanResult.sort((left, right) => right.rssi.compareTo(left.rssi));
          scanResults.clear();
          for (ScanResult result in scanResult) {
            if (result.rssi > 0) continue;
            scanResults.add(result);
          }
        });
      }
    });
  }

  void _connect(int index) async {
    BluetoothDevice device = scanResults[index].device;
    //跳转
    await device.connect();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (ctx) => Test(
                device: device,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomTopAppBar(
          title: '     选择设备',
          backButtonOnPressed: () {
            flutterBlue.stopScan();
          },
        ),
        body: RefreshIndicator(
            child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (BuildContext context, index) {
                ScanResult result = scanResults[index];
                return BluetoothDeviceListEntry(
                  device: result.device,
                  rssi: result.rssi,
                  onTap: () {
                    _connect(index);
                  },
                );
              },
            ),
            onRefresh: _onRefresh));
  }
}

class BluetoothDeviceListEntry extends ListTile {
  BluetoothDeviceListEntry({
    Key? key,
    required BluetoothDevice device,
    int? rssi,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    bool enabled = true,
  }) : super(
          key: key,
          onTap: onTap,
          onLongPress: onLongPress,
          enabled: enabled,
          leading: const Icon(Icons.devices),
          // @TODO . !BluetoothClass! class aware icon
          title: Text(device.name),
          subtitle: Text(device.id.id),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              rssi != null
                  ? Container(
                      margin: const EdgeInsets.all(8.0),
                      child: DefaultTextStyle(
                        style: _computeTextStyle(rssi),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(rssi.toString()),
                            const Text('dBm'),
                          ],
                        ),
                      ),
                    )
                  : Container(width: 0, height: 0),
              // device.isConnected
              //     ? Icon(Icons.import_export)
              //     : Container(width: 0, height: 0),
            ],
          ),
        );

  static TextStyle _computeTextStyle(int rssi) {
    /**/ if (rssi >= -35) {
      return TextStyle(color: Colors.greenAccent[700]);
    } else if (rssi >= -45) {
      return TextStyle(
          color: Color.lerp(
              Colors.greenAccent[700], Colors.lightGreen, -(rssi + 35) / 10));
    } else if (rssi >= -55) {
      return TextStyle(
          color: Color.lerp(
              Colors.lightGreen, Colors.lime[600], -(rssi + 45) / 10));
    } else if (rssi >= -65) {
      return TextStyle(
          color: Color.lerp(Colors.lime[600], Colors.amber, -(rssi + 55) / 10));
    } else if (rssi >= -75) {
      return TextStyle(
          color: Color.lerp(
              Colors.amber, Colors.deepOrangeAccent, -(rssi + 65) / 10));
    } else if (rssi >= -85) {
      return TextStyle(
          color: Color.lerp(
              Colors.deepOrangeAccent, Colors.redAccent, -(rssi + 75) / 10));
    } else {
      return const TextStyle(color: Colors.redAccent);
    }
  }
}
