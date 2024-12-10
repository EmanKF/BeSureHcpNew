import 'dart:convert';
import 'dart:developer';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantFontFamily.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Models/ChartData.dart';
import 'package:besure_hcp/Models/ReportTransactionDetails.dart';
import 'package:besure_hcp/Models/ChartDataCategory.dart';
import 'package:besure_hcp/Models/Report.dart';
import 'package:besure_hcp/Models/ReportTransaction.dart';
import 'package:besure_hcp/Models/StatisticsData.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/BranchesScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/Services/ReportsServices.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}
class o{
    
}
  
class _StatisticsScreenState extends State<StatisticsScreen> {
  Branch selectedBranchId = Branch();
  bool isLoading = false;
  int bId = BaseScreen.loggedInSP!.branchId!;
  List<Branch> branchNotAdmin = [];
  DateTime? fromDate, toDate;
  DateTime defaultDate = DateTime.now();
  // int? _radioValue = 0;
  // bool isTime = false;
  // List<ChartData> chartDataByTime = [];
  List<ChartDataCategory> chartData = []; 
  Report selectedReport = Report(id: 0, name: '');
  // Report selectedReportByTime = Report(id: 0, name: '');
  List<Report> reportsList = [];
  Map<String, List<ReportTransactionDetails>> groupedDataFinal = {};
  bool isSelected_fromDate = false, isSelected_toDate = false;

  // void _handleRadioValueChange(int? value){
  //   print('hohohooho');
  //   setState(() {
  //     print('hohohooho abl');
  //         _radioValue = value;
  //         print('hohohooho b3d');
  //         switch(_radioValue){
  //           case 0:
  //             isTime = false;
  //             break;
  //           case 1:
  //             isTime = true;
  //             break; 

  //         }
  //       });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(bId.toString());
    log(bId.toString());
    toDate = defaultDate;
    fromDate = defaultDate;
    log(bId.toString());
    
    if(bId != 0){
      for(Branch  b in BranchesScreen.approvedBranches){
        print(BranchesScreen.approvedBranches.length.toString()+' ffffffffffffff');
        if(b.serviceProviderBranchesId == bId ){
          print(BranchesScreen.approvedBranches.length.toString()+' ffffffffffffffh');
          log('honaaaaaa');
          branchNotAdmin.add(b);
          selectedBranchId = b;
        }
      }
    }

    if(reportsList.isEmpty){
      reportsList = [
        Report(id: 1, name: SplashScreen.langId == 1 ? 'Patients Report' : 'تقرير المرضى'),
        Report(id: 2, name: SplashScreen.langId == 1 ? 'Discount Report' : 'تقرير الخصومات'),
      ];
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 10,
      ),
      body:        
          Container(
          color: Colors.white,
          width: 100.w,
          height: 100.h,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                 
                  SizedBox(
                    height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 5.h : 2.h,
                  ),

                //  SizedBox(
                //     width: MediaQuery.of(context).size.width,
                //     height: 25.h,
                //     child: SvgPicture.asset('assets/images/bgHue.svg',
                //         fit: BoxFit.fill, color: silverLakeBlue)),
                
                Container(
                  width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(
                      //   width: 10.w,
                      // ),
                      Text(
                        AppLocalizations.of(context)!.statistics,
                        style:
                            TextStyle(
                              color: silverLakeBlue,
                              fontSize:  MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 8.sp : 18.sp, 
                              fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null,
                              fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                
                Column(
                  children:[ 
                    if(bId == 0)
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                           width:  MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                           child: DropdownButtonFormField( 
                                  items: BranchesScreen.approvedBranches.map((Branch value){
                                    return DropdownMenuItem<String>(
                                      value: value.serviceProviderBranchesId.toString(),
                                      child: Container(
                                        width: 160,
                                        child: Text(value.name!, style: TextStyle(fontSize: 12),)),
                                    );
                                  }).toList(),
                                  validator: (val){
                                    //  if(val == null)
                                    //  return 'Select Branch';
                                    //  else return null;
                                  },
                                  onChanged: (v) async{
                                    print(v.toString());  
                                    // servicesByBranch = await getAllApprovedServices(int.parse(v.toString()));  
                                    for(Branch  b in BranchesScreen.approvedBranches){
                                      if(b.serviceProviderBranchesId == int.parse(v.toString())){
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
                           width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                           child: DropdownButtonFormField( 
                           
                                  items: branchNotAdmin.map((Branch value){
                                    return new DropdownMenuItem<String>(
                                      value: value.id.toString(),
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
                           width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                           child: DropdownButtonFormField( 
                           
                                  items: reportsList.map((Report value){
                                    return new DropdownMenuItem<String>(
                                      value: value.id.toString(),
                                      child: Container(
                                        width: 160,
                                        child: Text(value.name!, style: TextStyle(fontSize: 12),)),
                                    );
                                  }).toList(),
                                  validator: (val){
                                     if(val == null)
                                     return 'Select Service Type';
                                     else return null;
                                  },
                                  onChanged: (val){
                                    // chartData.clear();
                                     for(Report r in reportsList){
                                      if(r.id.toString() == val){
                                        selectedReport = r;
                                      }
                                     }
                                     setState(() {
                                       
                                     });
                                  },
                
                                    hint: Text(selectedReport.id == 0 ? AppLocalizations.of(context)!.type : selectedReport!.name!, style:  TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: silverLakeBlue
                                        )
                                    ),
                                    decoration: InputDecoration( 
                                      prefixIcon: Icon(Icons.apps, size:30),
                                      border: OutlineInputBorder(
                
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: silverLakeBlue, width: 1),
                                    ),
                                   ),
                                ),                                                                                                                                                                                                                                                                                                
                         ), 

                        Container(
                  width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 90.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade500 )
                                )
                              ),
                              width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 19.w : 44.w,
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
                          width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 19.w : 44.w,
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
                    ),


                  ]),          
                
                
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
                  width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: silverLakeBlue
                  ),
                  child: TextButton(
                    onPressed: () async{

                        if(selectedReport.id == 0 || fromDate == null || toDate == null || selectedBranchId == null){
                          showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.allFieldsAreRequired));
                        }
                        else{
                          setState(() {
                            isLoading = true;
                          });

                          Map map = new Map();
                          chartData = [];
                          map['from'] = fromDate!.toIso8601String();
                          map['to'] = toDate!.toIso8601String();
                          map['userId'] = BaseScreen.loggedInSP!.serviceProvideId!;
                          map['branchId'] = selectedBranchId.serviceProviderBranchesId;
                          map['type'] = selectedReport.id;
                          map['is_Time'] = false;
                          map['is_SP'] = LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True" ? true : false;
                
                          log(json.encode(map));
                          List<ReportTransaction> reports = await getSPReportNew(map);

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
                      
                
                    child: Text(AppLocalizations.of(context)!.submit, style: TextStyle(color: Colors.white),)
                )),
                
                
                SizedBox(
                  height: 2.h,
                ),

                
                 
                if(groupedDataFinal.isNotEmpty && selectedReport!.id! == 2)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StatsBarChart(groupedData: groupedDataFinal),
                ),
                
                if(groupedDataFinal.isNotEmpty && selectedReport!.id! == 1)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StatsBarChart(groupedData: groupedDataFinal),
                ),
                      
                      
                  
                  
              
            ]),
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
