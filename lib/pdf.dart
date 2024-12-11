import 'dart:io';
import 'package:besure_hcp/Models/ClientReport.dart';
import 'package:besure_hcp/Models/DisplayReconcilation.dart';
import 'package:besure_hcp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:intl/intl.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';


Future<void> showDownloadNotification(String filePath) async {
  
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'download_channel', // Channel ID
    'Downloads', // Channel name
    channelDescription: 'Notification for completed downloads',
    importance: Importance.high,
    priority: Priority.high,
    icon: 'app_icon',
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(defaultPresentSound: true, defaultPresentBadge: true, defaultPresentAlert: true);

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );    

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: selectNotification
  );

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    'Download Complete', // Title
    'Tap to open your PDF: $filePath', // Body
    notificationDetails,
    payload: filePath, // Pass the file path as payload
  );

}

Future<void> selectNotification(NotificationResponse? payload) async {
  if (payload != null) {
    print('Notification tapped! Payload: $payload');
    // Open the PDF file from the payload
    // await OpenFile.open(payload.payload);
  }
}

String formatDate(String date){
    final String formattedDate = DateFormat('d-M-yyyy').format(DateTime.parse(date));
    return formattedDate;
  }


Future<void> generateAndNotifyPdf(DisplayReconcilation reconcilation, String from, String to) async {
  await requestStoragePermission();
  String f = formatDate(from);
  String t = formatDate(to);
  final pdf = pw.Document();
  try {
    // Generate and save PDF
    final directory = await getExternalStorageDirectory();
    // if (!await directory.exists()) {
    //   await directory.create(recursive: true);
    // }
    final ByteData fontData = await rootBundle.load('assets/fonts/NotoNaskhArabic-VariableFont_wght.ttf');
    final Uint8List fontBytes = fontData.buffer.asUint8List();
    final file = File('${directory!.path}/ReconcilationReport.pdf');
    final ByteData bytes = await rootBundle.load('assets/images/esnadTakaful.png');
    final Uint8List imageBytes = bytes.buffer.asUint8List();
    // final ttfArabic = pw.Font.ttf(fontBytes);
    // final pw.Font ttfEnglish = pw.Font.times();
        // Check if the document contains Arabic text
    // bool isArabic = containsArabic(text);



    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('ESNAD TAKAFUL', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Image(pw.MemoryImage(imageBytes), height: 80, width: 80)
                ]
              ),
              pw.SizedBox(height: 30),
              pw.Text("Reconcilation Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 50),
              
              pw.Row(
                children: [
                  pw.Text('Transactions List:'),
                  pw.Spacer(),
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(text: 'From: '),
                        pw.TextSpan(text: f)
                      ]
                    )
                  ),
                  pw.SizedBox(
                    width: 30
                  ),
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(text: 'To: '),
                        pw.TextSpan(text: t)
                      ]
                    )
                  ),
                ]
              ),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                data: <List<String>>[
                  ['Client','Branch','Payment Method','Date','Amount','Center','BeSure','Discount',],
                  for(ClientReport c in reconcilation.reportList!)
                  [c.clientName!,c.serviceProviderBranchName!,c.is_Paid_By_Amazon == true ? 'BeSure' : 'Cash',c.paymentId!.toString(),c.amount.toString(),c.centerAmount.toString(),(c.amount! - c.centerAmount!).toString(), c.discount.toString()]
                ]
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                children: [
                  pw.Text('Summary:')
                ]
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.RichText(text: pw.TextSpan(
                        children: [
                          pw.TextSpan(text: 'SAR Collection: '),
                          pw.TextSpan(text: (reconcilation.transactionBesurePayment! + reconcilation.transactionTotalCenterCash!).toString()),
                          pw.TextSpan(text: ' SAR')
                        ]
                      )),
                      pw.RichText(text: pw.TextSpan(
                        children: [
                          pw.TextSpan(text: 'Center: '),
                          pw.TextSpan(text: reconcilation.transactionTotalCenterCash!.toString()),
                          pw.TextSpan(text: ' SAR')
                        ]
                      )),
                      pw.RichText(text: pw.TextSpan(
                        children: [
                          pw.TextSpan(text: 'BeSure: '),
                          pw.TextSpan(text: reconcilation.transactionBesurePayment!.toString()),
                          pw.TextSpan(text: ' SAR')
                        ]
                      ))
                    ]
                  ),

                  pw.Column(
                    children: [
                      pw.RichText(text: pw.TextSpan(
                        children: [
                          pw.TextSpan(text: 'Total Commission Deductions:'),
                        ]
                      )),

                      // pw.RichText(text: pw.TextSpan(
                      //   children: [
                      //     pw.TextSpan(text: 'Deductions: '),
                      //     pw.TextSpan(text: '(0'),
                      //     pw.TextSpan(text: '%)')
                      //   ]
                      // )),
                      
                      pw.RichText(text: pw.TextSpan(
                        children: [
                          pw.TextSpan(text: 'In Center: '),
                          pw.TextSpan(text: reconcilation.centerCashCommission!.toString()),
                          pw.TextSpan(text: ' SAR')
                        ]
                      )),
                      pw.RichText(text: pw.TextSpan(
                        children: [
                          pw.TextSpan(text: 'With BeSure: '),
                          pw.TextSpan(text: reconcilation.besureAmazonComission!.toString()),
                          pw.TextSpan(text: ' SAR')
                        ]
                      ))
                    ]
                  ),

                  pw.Column(
                    children: [
                      pw.RichText(text: pw.TextSpan(
                        children: [
                          pw.TextSpan(text: 'Transfers/Settlements: '),
                          // pw.TextSpan(text: (reconcilation.transactionBesurePayment! + reconcilation.transactionTotalCenterCash!).toString()),
                          // pw.TextSpan(text: ' SAR')
                        ]
                      )),
                      pw.RichText(text: pw.TextSpan(
                        children: [
                          pw.TextSpan(text: 'From HCP: '),
                          pw.TextSpan(text: reconcilation.transferFromHCPToBeSure!.toString()),
                          pw.TextSpan(text: ' SAR')
                        ]
                      )),
                      pw.RichText(text: pw.TextSpan(
                        children: [
                          pw.TextSpan(text: 'To HCP: '),
                          pw.TextSpan(text: reconcilation.transferFromBeSureToHCP!.toString()),
                          pw.TextSpan(text: ' SAR')
                        ]
                      ))
                    ]
                  )
                ]
              ),
              
              pw.SizedBox(height: 20),
            ],
          );
        },
      ),
    );

    file.writeAsBytes(await pdf.save());

    // Show notification
    await showDownloadNotification(file.path);
  } catch (e) {
    print("Error: $e");
  }
}

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.status;
  print(status);
  if (!status.isGranted) {
    await Permission.storage.request();
  }
 
}

// Future<void> openPdf(String filePath) async {
//   await OpenFile.open(filePath);
// }

bool containsArabic(String text) {
    // Arabic Unicode range (0600-06FF)
    final arabicPattern = RegExp(r'[\u0600-\u06FF]');
    return arabicPattern.hasMatch(text);
}