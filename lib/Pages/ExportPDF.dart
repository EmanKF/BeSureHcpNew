import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class PDFExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Export to PDF Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final data = [
                {'name': 'Service A', 'reason': 'Reason 1'},
                {'name': 'Service B', 'reason': 'Reason 2'},
              ];
              final pdf = await createPDF(data);
              await savePDF(pdf);
              previewPDF(pdf); // Preview the PDF
            },
            child: Text('Export to PDF'),
          ),
        ),
      ),
    );
  }

  Future<pw.Document> createPDF(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: data.map((item) {
              return pw.Text(
                '${item['name']}: ${item['reason']}',
                style: pw.TextStyle(fontSize: 14),
              );
            }).toList(),
          );
        },
      ),
    );
    return pdf;
  }

  Future<void> savePDF(pw.Document pdf) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/example.pdf');
    await file.writeAsBytes(await pdf.save());
    print('PDF saved to ${file.path}');
  }

  Future<void> previewPDF(pw.Document pdf) async {
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}

void main() {
  runApp(PDFExample());
}
