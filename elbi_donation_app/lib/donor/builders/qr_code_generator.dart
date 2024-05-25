import 'dart:typed_data';
import 'dart:ui';

import 'package:elbi_donation_app/api/firebase_storage_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRCode extends StatefulWidget {
  final String donationID;
  final Function(String?) onQRCodeSaved;

  const GenerateQRCode({required this.donationID, required this.onQRCodeSaved, super.key});

  @override
  State<GenerateQRCode> createState() => _GenerateQRCodeState();
}

class _GenerateQRCodeState extends State<GenerateQRCode> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _saveQRImage(widget.donationID);
  }

  void _saveQRImage(String donationID) async {
    print("YESSSS");
    try {
      if (_repaintBoundaryKey.currentContext != null) {
            print("YESSSS11");
        RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        var image = await boundary.toImage(pixelRatio: 3.0);

        final recorder = PictureRecorder();
        final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
        final whitePaint = Paint()..color = Colors.white;
        canvas.drawRect(Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), whitePaint);
        canvas.drawImage(image, Offset.zero, Paint());
        final picture = recorder.endRecording();
        final img = await picture.toImage(image.width, image.height);

        ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
        Uint8List imageData = byteData!.buffer.asUint8List();

        String downloadURL = await context.read<FirebaseStorageAPI>().addQRimg(imageData, donationID);
        widget.onQRCodeSaved(downloadURL);
      }
    } catch (e) {
      print('Error saving QR code image: $e');
      widget.onQRCodeSaved(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(5),
      child: RepaintBoundary(
        key: _repaintBoundaryKey,
        child: QrImageView(
          data: widget.donationID,
          version: QrVersions.auto,
          size: 100,
          gapless: false,
        ),
      ),
    );
  }
}
