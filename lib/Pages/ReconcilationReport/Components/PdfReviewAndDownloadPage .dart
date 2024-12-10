import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class PdfDownloadScreen extends StatefulWidget {
  final String pdfUrl;

  PdfDownloadScreen({required this.pdfUrl});

  @override
  _PdfDownloadScreenState createState() => _PdfDownloadScreenState();
}

class _PdfDownloadScreenState extends State<PdfDownloadScreen> {
  String? localPath;
  late PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    _downloadPdf(widget.pdfUrl);
  }

  Future<void> _downloadPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/downloaded_pdf.pdf';
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        setState(() {
          localPath = filePath;
        });

        _initializePdfController(filePath);
      } else {
        throw Exception('Failed to download PDF');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }

  // Initialize the PDF controller from the downloaded file
  void _initializePdfController(String filePath) {
    _pdfController = PdfController(
      document: PdfDocument.openFile(filePath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      body: localPath == null
          ? Center(child: CircularProgressIndicator()) // Show loading while downloading
          : Center(
              child: PdfView(
                controller: _pdfController,
                scrollDirection: Axis.vertical,  // Set the scroll direction to vertical
                // z: 1,  // Adjust the zoom steps (higher = more zoom options)
              ),
            ),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }
}