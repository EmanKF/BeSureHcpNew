import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PdfDownloadScreen extends StatefulWidget {
  final String pdfUrl;

  PdfDownloadScreen({required this.pdfUrl});

  @override
  _PdfDownloadScreenState createState() => _PdfDownloadScreenState();
}

class _PdfDownloadScreenState extends State<PdfDownloadScreen> {
  String? localPath;
   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // _downloadPdf(widget.pdfUrl);
  }

  // Future<void> _downloadPdf(String url) async {
  //   try {
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final bytes = response.bodyBytes;

  //       final dir = await getApplicationDocumentsDirectory();
  //       final filePath = '${dir.path}/downloaded_pdf.pdf';
  //       final file = File(filePath);
  //       await file.writeAsBytes(bytes);

  //       setState(() {
  //         localPath = filePath;
  //       });

  //       _initializePdfController(filePath);
  //     } else {
  //       throw Exception('Failed to download PDF');
  //     }
  //   } catch (e) {
  //     print('Error downloading PDF: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.previewPdf),
      ),
      body:Center(
              child: SfPdfViewer.network(
                widget.pdfUrl,
                key: _pdfViewerKey,
              ),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}