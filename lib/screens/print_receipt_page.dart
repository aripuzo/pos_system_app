import 'package:flutter/material.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

class PrintReceiptPage extends StatefulWidget {
  @override
  _PrintReceiptPageState createState() => _PrintReceiptPageState();
}

class _PrintReceiptPageState extends State<PrintReceiptPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> devices = [];
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));
    bluetoothPrint.scanResults.listen((val) {
      setState(() {
        devices = val;
      });
    });

    bluetoothPrint.state.listen((state) {
      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            isConnected = true;
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            isConnected = false;
          });
          break;
        default:
          break;
      }
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    await bluetoothPrint.connect(device);
  }

  void printReceipt() async {
    if (!isConnected) return;

    Map<String, dynamic> config = Map();
    final List<LineText> bytes = [];

    bytes.add(LineText(type: LineText.TYPE_TEXT, content: 'Receipt', weight: 1, align: LineText.ALIGN_CENTER,linefeed: 1));

    bytes.add(LineText(linefeed: 1));

    bytes.add(LineText(type: LineText.TYPE_TEXT, content: 'Item 1   \$10.00', weight: 1, align: LineText.ALIGN_CENTER, linefeed: 1));
    bytes.add(LineText(type: LineText.TYPE_TEXT, content: 'Item 2   \$20.00', weight: 1, align: LineText.ALIGN_CENTER, linefeed: 1));
    bytes.add(LineText(type: LineText.TYPE_TEXT, content: 'Total   \$30.00', weight: 2, align: LineText.ALIGN_CENTER, linefeed: 1));
    bytes.add(LineText(linefeed: 1));

    bytes.add(LineText(type: LineText.TYPE_TEXT, content: 'Thank you', weight: 1, align: LineText.ALIGN_CENTER));

    await bluetoothPrint.printReceipt(config, bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Print Receipt')),
      body: Column(
        children: [
          if (devices.isEmpty)
            Center(child: Text('No devices found'))
          else
            ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devices[index].name ?? ''),
                  subtitle: Text(devices[index].address ?? ''),
                  onTap: () {
                    connectToDevice(devices[index]);
                  },
                );
              },
            ),
          if (isConnected)
            ElevatedButton(
              onPressed: printReceipt,
              child: Text('Print Receipt'),
            ),
        ],
      ),
    );
  }
}