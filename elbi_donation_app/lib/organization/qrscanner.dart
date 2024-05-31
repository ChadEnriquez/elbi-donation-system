import 'dart:typed_data';

import 'package:elbi_donation_app/provider/donation_provider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class OrgScanQRCodePage extends StatefulWidget {
  const OrgScanQRCodePage({super.key});

  @override
  State<OrgScanQRCodePage> createState() => _OrgScanQRCodePageState();
}

class _OrgScanQRCodePageState extends State<OrgScanQRCodePage> {
  late Size screen = MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("QR Scanner"),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                width: screen.width,
                height: screen.width,
                child: MobileScanner(
                  controller: MobileScannerController(
                      detectionSpeed: DetectionSpeed.noDuplicates, returnImage: true),
                  onDetect: (capture) {
                    final List<Barcode> barcode = capture.barcodes;
                    final Uint8List? image = capture.image;
                    for (final barcode in barcode) {
                      print("Barcode: ${barcode.rawValue}");
                    }

                    if (image != null) {
                      String? id = barcode.first.rawValue;
                      context.read<DonationsProvider>().editStatus(id!, "Confirmed");
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(barcode.first.rawValue ?? "No QR Code Found"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.memory(image),
                                  const Text(
                                      "Successfully Confirmed donation drop-off!",
                                      style: TextStyle(fontSize: 20)),
                                ],
                              ),
                            );
                          });
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Scan the QR Code to confirm the drop-off donation.",
                    style: TextStyle(fontSize: 20)),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel",
                      style: TextStyle(fontSize: 20)))
            ],
          ),
        ));
  }
}
