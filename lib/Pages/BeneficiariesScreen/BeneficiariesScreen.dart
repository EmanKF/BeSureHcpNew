import 'dart:convert';
import 'dart:developer';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Models/Month.dart';
import 'package:besure_hcp/Models/DateType.dart';
import 'package:besure_hcp/Models/ChartData.dart';
import 'package:besure_hcp/Models/ChartDataCategory.dart';
import 'package:besure_hcp/Models/ReportTransaction.dart';
import 'package:besure_hcp/Models/ReportTransactionDetails.dart';
import 'package:besure_hcp/Models/StatisticsData.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/BranchesScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Services/ReportsServices.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BeneficiariesScreen extends StatefulWidget {
  const BeneficiariesScreen({super.key});

  @override
  State<BeneficiariesScreen> createState() => _BeneficiariesScreenState();
}

class _BeneficiariesScreenState extends State<BeneficiariesScreen> {
  Branch selectedBranchId = Branch();
  Map<String, List<ReportTransactionDetails>> groupedDataFinal = {};
  int bId = BaseScreen.loggedInSP!.branchId!;
  List<Branch> branchNotAdmin = [];
  DateTime? fromDate, toDate;
  DateTime defaultDate = DateTime.now();
  bool isLoading = false, isSelected_fromDate = false, isSelected_toDate = false;
  // List<ChartData> chartDataByTime = [];
  List<ChartDataCategory> chartData = [];
  List<StatisticsData> statsData = List<StatisticsData>.empty(growable: true);
   List<ReportTransaction> reports = List.empty(growable: true);
  //  List<ReportTransaction> reportsByMonth = List.empty(growable: true);
   List<DateType> dateTypes =[];
   List<Month> months = [];
   int selectedDateTypeVal = 1;
   int selectedMonthVal =1;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toDate = defaultDate;
    fromDate = defaultDate;
    if(bId != 0){
      for(Branch  b in BranchesScreen.approvedBranches){
        if(b.serviceProviderBranchesId == bId ){
          branchNotAdmin.add(b);
          selectedBranchId = b;
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
    months = [
    Month(id: 1, name: AppLocalizations.of(context)!.jan),
    Month(id: 2, name: AppLocalizations.of(context)!.feb),
    Month(id: 3, name: AppLocalizations.of(context)!.mar),
    Month(id: 4, name: AppLocalizations.of(context)!.apr),
    Month(id: 5, name: AppLocalizations.of(context)!.may),
    Month(id: 6, name: AppLocalizations.of(context)!.jun),
    Month(id: 7, name: AppLocalizations.of(context)!.jul),
    Month(id: 8, name: AppLocalizations.of(context)!.aug),
    Month(id: 9, name: AppLocalizations.of(context)!.sep),
    Month(id: 10, name: AppLocalizations.of(context)!.oct),
    Month(id: 11, name: AppLocalizations.of(context)!.nov),
    Month(id: 12, name: AppLocalizations.of(context)!.dec)];
    dateTypes =[DateType(id: 1, name: AppLocalizations.of(context)!.byMonth), DateType(id: 2, name: AppLocalizations.of(context)!.byDate)];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        title: Text(AppLocalizations.of(context)!.beneficiaries),
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
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
    
            if(bId == 0)
                Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                       width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 45.w ,
                       child: DropdownButtonFormField( 
                              items: BranchesScreen.approvedBranches.map((Branch value){
                                return new DropdownMenuItem<String>(
                                  value: value.serviceProviderBranchesId.toString(),
                                  child: Container(
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
                                        setState(() {
                                          groupedDataFinal.clear();
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
                       width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 45.w ,
                       child: DropdownButtonFormField( 
                       
                              items: branchNotAdmin.map((Branch value){
                                return new DropdownMenuItem<String>(
                                  value: value.serviceProviderBranchesId.toString(),
                                  child: Container(
                                    child: Text(value.name!, style: TextStyle(fontSize: 12),)),
                                );
                              }).toList(),
                              validator: (val){
                                 if(val == null)
                                 return 'Select Branch';
                                 else return null;
                              },
                              onChanged: null,

                                hint: Text(branchNotAdmin.first.name!, style:  TextStyle(
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
            Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                       width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 45.w ,
                       child: DropdownButtonFormField( 
                       
                              items: dateTypes.map((DateType value){
                                return new DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Container(
                                    child: Text(value.name!, style: TextStyle(fontSize: 12),)),
                                );
                              }).toList(),
                              validator: (val){
                                 if(val == null)
                                 return 'Select Date Type';
                                 else return null;
                              },
                              onChanged: (val){
                                log(val!);
                                setState((){
                                  groupedDataFinal.clear();
                                  selectedDateTypeVal = int.parse(val);
                                });
                              },

                                hint: Text(dateTypes.first.name!, style:  TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: silverLakeBlue
                                    )
                                ),
                                decoration: InputDecoration( 
                                  prefixIcon: Icon(Icons.date_range_rounded, size:30),
                                  border: OutlineInputBorder(

                                  ),
                                  focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: silverLakeBlue, width: 1),
                                ),
                               ),
                            ),                                                                                                                                                                                                                                                                                                
                     ),
              ]
            ),
            
            if(selectedDateTypeVal == 2)
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
                                  Text(AppLocalizations.of(context)!.from,textAlign: TextAlign.start, style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.w100, fontSize: 10),),

                                  Text(
                                      fromDate != null ? fromDate.toString().split(' ').first.toString() : defaultDate.toString().split(' ').first.toString(),
                                      textScaleFactor: 1.0,
                                      style: TextStyle(color: isSelected_fromDate == false ?  azureishBlue : silverLakeBlue, fontWeight: FontWeight.bold,fontSize: 14)
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
                                        showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.dateValidationTo));
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
                              Text(AppLocalizations.of(context)!.to,textAlign: TextAlign.start, style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.w100, fontSize: 10),),
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

            if(selectedDateTypeVal == 1)
            Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                       width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 70.w : 93.w ,
                       child: DropdownButtonFormField( 
                       
                              items: months.map((Month value){
                                return new DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Container(
                                    width: 160,
                                    child: Text(value.name!, style: TextStyle(fontSize: 12),)),
                                );
                              }).toList(),
                              validator: (val){
                                 if(val == null)
                                 return 'Select Month';
                                 else return null;
                              },
                              onChanged: (val){
                                setState((){
                                  groupedDataFinal.clear();
                                  selectedMonthVal = int.parse(val!);
                                });
                              },

                                hint: Text(months.first.name!, style:  TextStyle(
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

            SizedBox(
              height: 1.h,
            ),

            isLoading == true ?
                Lottie.asset(
                        'assets/animations/loadingStatisticsAnimation.json',
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 20.w : 60.w,
                        height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 20.w : 60.w,
                      )
            :

            Container(
              width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 70.w : 93.w ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: silverLakeBlue
              ),
              child: TextButton(
                onPressed: () async{
                  if(selectedDateTypeVal == 1){
                     setState(() {
                          isLoading = true;
                        });
                        chartData = [];
                        Map map = new Map();
                        int year = DateTime.now().year;
                        DateTime firstDayOfMonth = DateTime(year, selectedMonthVal, 1);
                        DateTime lastDayOfMonth = DateTime(year, selectedMonthVal + 1, 0);
                        map['from'] = firstDayOfMonth.toIso8601String();
                        map['to'] = lastDayOfMonth.toIso8601String();
                        map['userId'] = BaseScreen.loggedInSP!.serviceProvideId!;
                        map['branchId'] = selectedBranchId.serviceProviderBranchesId;
                        map['type'] = 1;
                        map['is_Time'] = false;
                        map['is_SP'] = LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True" ? true : false;
                        
                        log(json.encode(map));
                        reports = await getSPReportNew(map);
                        Map<String, List<ReportTransactionDetails>> groupedData = {};
                        if(reports.isNotEmpty){
                        for(var r in reports.first.tranactionDetail!){
                          DateTime d = DateTime.parse(r.date!);
                          if(d.month == selectedMonthVal){
                            
                            var d = DateTime.parse(r.date!);
                            String formattedDate = "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
                            
                            if (groupedData.containsKey(formattedDate)) {
                              groupedData[formattedDate]!.add(r);
                            } else {
                              groupedData[formattedDate] = [r];
                            }
                            setState(() {
                              groupedDataFinal = groupedData;
                            });
                          }
                        }
                        groupedData.forEach((date, dataList) {
                            print("Date: $date");
                            for (var data in dataList) {
                              print("  - ${data.employeeName}: ${dataList.length}");
                            }
                          });
                        }

                          setState(() {
                            isLoading = false;
                          });
                  }
                  else{
                  if(fromDate == null || toDate == null){
                    showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.allFieldsAreRequired));
                  }
                  else{
                    setState(() {
                          isLoading = true;
                        });
                        chartData = [];
                        Map map = new Map();
                        map['from'] = fromDate!.toIso8601String();
                        map['to'] = toDate!.toIso8601String();
                        map['userId'] = BaseScreen.loggedInSP!.serviceProvideId!;
                        map['branchId'] = selectedBranchId.serviceProviderBranchesId;
                        map['type'] = 1;
                        map['is_Time'] = false;
                        map['is_SP'] = LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True" ? true : false;
                        
                        log(json.encode(map));
                        reports = await getSPReportNew(map);

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
                          ///

                        ////////////////////////////////
                        
                          String month = '';
                          // for (var data in reports.first.tranactionDetail!) {
                          if(reports.isNotEmpty){
                          for(ReportTransactionDetails r in reports.first.tranactionDetail!){
                            log(reports.first.tranactionCount.toString());
                            month = getMonthName(DateTime.parse(r.date.toString()).month);
                            statsData.add(StatisticsData(month,reports.length));
                          }
                          }
                      setState(() {
                        isLoading = false;
                      });
                    
                  }
                  }
                }, 
                child: Text(AppLocalizations.of(context)!.getBeneficiaries, style: TextStyle(color: Colors.white),))
            ),

            SizedBox(
              height: 5.h,
            ),

            if(groupedDataFinal.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StatsBarChart(groupedData: groupedDataFinal),
              ),

              
        
                 
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
      height: 250,
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
                reservedSize: 50,
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  // Show date labels
                  String dateLabel = groupedData.keys.elementAt(value.toInt());
                  DateTime dt = DateTime.parse(dateLabel);
                  int year = dt.year;
                  int month = dt.month;
                  String monthName = DateFormat('MMM').format(DateTime(2024, month));
                  int day = dt.day;
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Column(
                      children: [
                        Text(day.toString(), style: TextStyle(fontSize: 10)),
                        Text(monthName, style: TextStyle(fontSize: 10)),
                        Text(year.toString(), style: TextStyle(fontSize: 10)),
                      ],
                    ),
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
