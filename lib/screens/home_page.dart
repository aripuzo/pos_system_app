import 'package:flutter/material.dart';
import 'qr_scanner_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? qrResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('POS System')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScannerPage()),
                );
                setState(() {
                  qrResult = result;
                });
              },
              child: Text('Scan QR Code'),
            ),
            if (qrResult != null) Text('Scanned QR Code: $qrResult'),
            // Implement payment amount pre-fill logic here (optional)
          ],
        ),
      ),
    );
  }
}