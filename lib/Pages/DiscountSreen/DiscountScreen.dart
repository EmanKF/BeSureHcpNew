import 'dart:convert';
import 'dart:developer';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Models/ChartData.dart';
import 'package:besure_hcp/Models/ChartDataCategory.dart';
import 'package:besure_hcp/Models/ReportTransaction.dart';
import 'package:besure_hcp/Models/ReportTransactionDetails.dart';
import 'package:besure_hcp/Models/StatisticsData.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/BranchesScreen.dart';
import 'package:besure_hcp/Pages/DiscountSreen/singleTrans.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Services/ReportsServices.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  Branch selectedBranchId = Branch();
  int bId = BaseScreen.loggedInSP!.branchId!;
  List<Branch> branchNotAdmin = [];
  Map<String, List<ReportTransactionDetails>> groupedDataFinal = {};
  DateTime? fromDate, toDate;
  DateTime defaultDate = DateTime.now();
  bool isTime = false,isLoading = false, isSelected_fromDate = false, isSelected_toDate = false;
  List<ChartData> chartDataByTime = [];
  List<ChartDataCategory> chartDataByBranch = [];

   
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromDate = defaultDate;
    toDate = defaultDate;
    if(bId != 0){
      for(Branch  b in BranchesScreen.approvedBranches){
        if(b.serviceProviderBranchesId == bId ){
          branchNotAdmin.add(b);
          selectedBranchId = b!;
        }
      }
    }
  }
  
    String getMonthName(int monthNumber) {
  // Ensure the month number is between 1 and 12
  if (monthNumber < 1 || monthNumber > 12) {
    throw ArgumentError("Month number must be between 1 and 12");
  }
  
  // Create a DateTime object with the month and a default day/year
  final date = DateTime(0, monthNumber);
  
  // Format the DateTime to display only the month name
  return DateFormat.MMMM().format(date);
}


  @override
  Widget build(BuildContext context) {
    List<StatisticsData> statsData = List<StatisticsData>.empty(growable: true);
    List<ReportTransaction> reportss = List<ReportTransaction>.empty(growable: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        title: Text(AppLocalizations.of(context)!.discounts),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        width: 100.w,
        height: 100.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            if(MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height)
            SizedBox(
              height: 5.h,
            ),
            
            if(bId == 0)
                Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                       width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 70.w : 85.w ,
                       child: DropdownButtonFormField( 
                              items: BranchesScreen.approvedBranches.map((Branch value){
                                return new DropdownMenuItem<String>(
                                  value: value.serviceProviderBranchesId.toString(),
                                  child: Container(
                                    width: 160,
                                    child: Text(value.name!, style: TextStyle(fontSize: 12),)),
                                );
                              }).toList(),
                              validator: (val){
                                 if(val == null)
                                 return 'Select Branch';
                                 else return null;
                              },
                              onChanged: (v) async{
                                for(Branch  b in BranchesScreen.approvedBranches){
                                      if(b.serviceProviderBranchesId == int.parse(v.toString())){
                                        print(b.serviceProviderBranchesId.toString());
                                        setState(() {
                                          selectedBranchId = b;
                                        }); 
                                      }
                                    }                        
                              },

                                hint: Text(AppLocalizations.of(context)!.branch, style:  TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: silverLakeBlue
                                    )
                                ),
                                decoration: InputDecoration( 
                                  prefixIcon: Icon(Icons.apartment_rounded, size:30),
                                  border: OutlineInputBorder(

                                  ),
                                  focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: silverLakeBlue, width: 1),
                                ),
                               ),
                            ),                                                                                                                                                                                                                                                                                                
                     ),

            if(bId != 0)
              Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                       width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 70.w : 90.w ,
                       child: DropdownButtonFormField( 
                       
                              items: branchNotAdmin.map((Branch value){
                                return new DropdownMenuItem<String>(
                                  value: value.serviceProviderBranchesId.toString(),
                                  child: Container(
                                    width: 160,
                                    child: Text(value.name!, style: TextStyle(fontSize: 12),)),
                                );
                              }).toList(),
                              validator: (val){
                                 if(val == null)
                                 return 'Select Branch';
                                 else return null;
                              },
                              onChanged: null,

                                hint: Text(branchNotAdmin.isEmpty ? '' : branchNotAdmin.first.name!, style:  TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: silverLakeBlue
                                    )
                                ),
                                decoration: InputDecoration( 
                                  prefixIcon: Icon(Icons.apartment_rounded, size:30),
                                  border: OutlineInputBorder(

                                  ),
                                  focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: silverLakeBlue, width: 1),
                                ),
                               ),
                            ),                                                                                                                                                                                                                                                                                                
                     ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade500 )
                          )
                        ),
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 28.w : 44.w ,
                        child: TextButton(
                        onPressed: () async{
                           final DateTime? picked = await showDatePicker(
                                        helpText: AppLocalizations.of(context)!.from,
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2024)
                                            .add(const Duration(days: 360)),
                                        );
                                    if (picked != null) {
                                       if(picked.isAfter(toDate!)){
                                        showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.dateValidationFrom));
                                        print('nooooooooooooo');
                                      }
                                      else{
                                      setState(() {
                                        fromDate = picked;
                                        isSelected_fromDate = true;
                                      });
                                      }
                                    }
                          },
                          
                          child: Row(
                            children: [
                              Icon(Icons.event_rounded, color: isSelected_fromDate == false ?  azureishBlue : silverLakeBlue, size: 30,),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('From Date',textAlign: TextAlign.start, style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.w100, fontSize: 10),),
                                  Text(
                                      fromDate != null ? fromDate.toString().split(' ').first.toString() : defaultDate.toString().split(' ').first.toString(),
                                      textScaleFactor: 1.0,
                                      style: TextStyle(color: isSelected_fromDate == false ?  azureishBlue : silverLakeBlue, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                        ),

              Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade500 )
                      )
                    ),
                    width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 28.w : 44.w ,
                    child: TextButton(
                    onPressed: () async{
                       final DateTime? picked = await showDatePicker(
                                    helpText: AppLocalizations.of(context)!.to,
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2024)
                                        .add(const Duration(days: 360)));
                                if (picked != null) {
                                  if(picked.isBefore(fromDate!)){
                                        showDialog(context: context, builder: (context) => MsgDialog(msg:AppLocalizations.of(context)!.dateValidationTo));
                                        print('nooooooooooooo');
                                      }
                                      else{
                                      setState(() {
                                        toDate = picked;
                                        isSelected_toDate = true;
                                      });
                                      }
                                }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.event_rounded, color: isSelected_toDate == false ?  azureishBlue : silverLakeBlue, size: 30,),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('To Date',textAlign: TextAlign.start, style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.w100, fontSize: 10),),
                              Text(
                                  toDate != null ? toDate.toString().split(' ').first.toString() : defaultDate.toString().split(' ').first.toString(),
                                  textScaleFactor: 1.0,
                                  style: TextStyle(color: isSelected_toDate == false ?  azureishBlue : silverLakeBlue, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ),

              ],
            ),

            SizedBox(
              height: 2.h,
            ),

            isLoading == true ?
                Lottie.asset(
                        'assets/animations/loadingStatisticsAnimation.json',
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 20.w : 60.w,
                        height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 20.w : 60.w,
                      )
                      :

            Container(
             width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 70.w : 85.w ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: silverLakeBlue
              ),
              child: TextButton(
                onPressed: () async{
                  if(fromDate == null || toDate == null){
                    showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.allFieldsAreRequired));
                  }
                  else{
                    setState(() {
                        isLoading = true;
                      });
                    Map map = new Map();
                      chartDataByBranch = [];
                      map['from'] = fromDate!.toIso8601String();
                      map['to'] = toDate!.toIso8601String();
                      map['userId'] = BaseScreen.loggedInSP!.serviceProvideId!;
                      map['branchId'] = selectedBranchId.serviceProviderBranchesId;
                      map['type'] = 2;
                      map['is_Time'] = false;
                      map['is_SP'] = LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True" ? true : false;

                      log(json.encode(map));
                          List<ReportTransaction> reports = await getSPReportNew(map);
                          setState(() {
                            reportss = reports;
                          });
                          ///////////////////////////////////
                          Map<String, List<ReportTransactionDetails>> groupedData = {};
                          if(reports.isNotEmpty)
                          for (var data in reports.first.tranactionDetail!) {
                            var d = DateTime.parse(data.date!);
                            String formattedDate = "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
                            
                            if (groupedData.containsKey(formattedDate)) {
                              groupedData[formattedDate]!.add(data);
                            } else {
                              groupedData[formattedDate] = [data];
                            }
                            setState(() {
                              groupedDataFinal = groupedData;
                            });
                          }

                          groupedData.forEach((date, dataList) {
                            print("Date: $date");
                            for (var data in dataList) {
                              print("  - ${data.employeeName}: ${dataList.length}");
                            }
                          });
                          //////////////////////////////////
                          
                       


                          ////////////////////////////////
                        
                          String month = '';
                          if(reports.isNotEmpty)
                          for(ReportTransactionDetails r in reports.first.tranactionDetail!){
                            print(reports.first.tranactionCount.toString());
                            month = getMonthName(DateTime.parse(r.date.toString()).month);
                            statsData.add(StatisticsData(month,reports.length));
                          
                            // ChartDataCategory c = ChartDataCategory(report.branchName!.toString(),report.tranactionCount!);
                            // chartData.add(c);
                          }
                      setState(() {
                        isLoading = false;
                      });
                  }
                }, 
                child: Text(AppLocalizations.of(context)!.getDiscounts, style: TextStyle(color: Colors.white),))
            ),

            // SizedBox(
            //   height: 2.h,
            // ),

            //  Container(
            //   margin: EdgeInsets.symmetric(horizontal: 8.w),
            //   width: 100.w,
            //   child: Text('Total Patients', style: TextStyle(
            //     fontSize: 14.sp,
            //     fontWeight: FontWeight.w600,
            //     color: darkPastelPurple
            //   )),
            // ),

            SizedBox(
              height: 5.h,
            ),

             if(groupedDataFinal.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StatsBarChart(groupedData: groupedDataFinal),
              ),
              if(reportss.isNotEmpty)
              for(ReportTransactionDetails r in reportss.first.tranactionDetail!)
              Text('ll')
        
                 
          ],
        ),
      ),
    );
  }
}

class StatsBarChart extends StatelessWidget {
  final Map<String, List<ReportTransactionDetails>> groupedData;

  StatsBarChart({required this.groupedData});

  List<BarChartGroupData> createBarChartData(Map<String, List<ReportTransactionDetails>> groupedData) {
            List<BarChartGroupData> barGroups = [];
            int xIndex = 0;

            groupedData.forEach((date, transactions) {
              int transactionCount = transactions.length;

              barGroups.add(
                BarChartGroupData(
                  x: xIndex,
                  barRods: [
                    BarChartRodData(
                      toY: transactionCount.toDouble(), // Number of transactions for the date
                      color: silverLakeBlue,
                      width: 25,
                    ),
                  ],
                  // showingTooltipIndicators: [0],
                ),
              );
              xIndex++;
            });

            return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: createBarChartData(groupedData),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, interval: 1),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  // Show date labels
                  String dateLabel = groupedData.keys.elementAt(value.toInt());
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(dateLabel, style: TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          // barTouchData: BarTouchData(
          //   touchTooltipData: BarTouchTooltipData(
              
          //     getTooltipItem: (group, groupIndex, rod, rodIndex) {
          //       String date = groupedData.keys.elementAt(groupIndex);
          //       return BarTooltipItem(
          //         '$date\n',
          //         TextStyle(color: Colors.white),
          //         children: [TextSpan(text: 'Value: ${rod.toY}')],
          //       );
          //     },
          //   ),
          // ),
        ),
      ),
    );
  }
}
