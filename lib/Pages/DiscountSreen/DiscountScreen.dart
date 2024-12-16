import 'dart:convert';
import 'dart:developer';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Models/ChartData.dart';
import 'package:besure_hcp/Models/ChartDataCategory.dart';
import 'package:besure_hcp/Models/DateType.dart';
import 'package:besure_hcp/Models/Month.dart';
import 'package:besure_hcp/Models/ReportServiceDetail.dart';
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
  List<ChartDataCategory> chartData = [];
  List<StatisticsData> statsData = List<StatisticsData>.empty(growable: true);
  List<ReportTransaction> reports = List<ReportTransaction>.empty(growable: true);
  List<DateType> dateTypes =[];
  List<Month> months = [];
  int selectedDateTypeVal = 1;
  int selectedMonthVal =1;
  List<RevenueData> revDates = List<RevenueData>.empty(growable: true);
   
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
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                                        print(b.serviceProviderBranchesId.toString());
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
                        setState(() {
                          revDates = groupTransactionsByDate(reports);
                          revDates = mergeObjectsByDate(revDates);
                        });

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
                    Map map = new Map();
                      chartData = [];
                      map['from'] = fromDate!.toIso8601String();
                      map['to'] = toDate!.toIso8601String();
                      map['userId'] = BaseScreen.loggedInSP!.serviceProvideId!;
                      map['branchId'] = selectedBranchId.serviceProviderBranchesId;
                      map['type'] = 2;
                      map['is_Time'] = false;
                      map['is_SP'] = LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True" ? true : false;

                      log(json.encode(map));
                          reports = await getSPReportNew(map);
                        setState(() {
                          revDates = groupTransactionsByDate(reports);
                          revDates = mergeObjectsByDate(revDates);
                        });

                          setState(() {
                            isLoading = false;
                          });
                  }
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

             if(revDates.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RevenueChartPage(rev: revDates)
              ),
        
                 
          ],
        ),
      ),
    );
  }
}


class RevenueData {
  final DateTime date;
  final double revenue;

  RevenueData(this.date, this.revenue);
}

List<RevenueData> groupTransactionsByDate(List<ReportTransaction> transactions) {
  // Create a map to hold total revenue for each date
  Map<String, double> groupedRevenue = {};

  for (var transaction in transactions) {
    if (transaction.tranactionDetail != null) {
      for (var detail in transaction.tranactionDetail!) {
        String? date = detail.date;

        // Sum the revenue for all services under this detail
        double totalRevenueForDetail = detail.servicesDetail?.fold(0.0, (sum, service) {
              return sum! + (service.amount ?? 0.0);
            }) ?? 0.0;

        if (date != null) {
          // Add or update the total revenue for the specific date
          groupedRevenue.update(
            date,
            (existingRevenue) => existingRevenue + totalRevenueForDetail,
            ifAbsent: () => totalRevenueForDetail,
          );
        }
      }
    }
  }

  // Convert the map to a list of RevenueData objects
  List<RevenueData> revenueDataList = groupedRevenue.entries.map((entry) {
    return RevenueData(DateTime.parse(entry.key), entry.value);
  }).toList();

  // Sort the list by date
  revenueDataList.sort((a, b) => a.date.compareTo(b.date));

  return revenueDataList;
}



class RevenueChartPage extends StatelessWidget {
  RevenueChartPage({super.key, this.rev});

  List<RevenueData>? rev;
  @override
  Widget build(BuildContext context) {
    // Sample data
    log(rev.toString());
    return Container(
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat('dd MMM'),  // Format the X-axis date
            title: AxisTitle(text: 'Date'),
          ),
          primaryYAxis: NumericAxis(
            // title: AxisTitle(text: 'Revenue'),
            numberFormat: NumberFormat.currency(
              locale: 'en_SA',
              symbol: 'SAR '
            ),
          ),
          series: <CartesianSeries>[
            ColumnSeries<RevenueData, DateTime>(
              dataSource: rev,
              xValueMapper: (RevenueData data, _) => data.date,
              yValueMapper: (RevenueData data, _) => data.revenue,
              color: silverLakeBlue,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
    );
  }
}

List<BarChartGroupData> createBarChartData(List<RevenueData> revenueDataList) {
  List<BarChartGroupData> barGroups = [];
  for (int i = 0; i <= revenueDataList.length; i++) {
    barGroups.add(
      BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: revenueDataList[i].revenue,
            color: Colors.blue,
            width: 25,
          ),
        ],
      ),
    );
  }
  return barGroups;
}


List<RevenueData> mergeObjectsByDate(List<RevenueData> objects) {
  // Create a map to group by date and sum amounts
  Map<DateTime, double> groupedMap = {};

  for (var obj in objects) {
    // Use only the date part to group by date (ignoring time)
    DateTime dateOnly = DateTime(obj.date.year, obj.date.month, obj.date.day);

    groupedMap.update(
      dateOnly,
      (existingAmount) => existingAmount + obj.revenue,
      ifAbsent: () => obj.revenue,
    );
  }

  // Convert the map back to a list of Object
  return groupedMap.entries.map((entry) {
    return RevenueData(entry.key, entry.value);
  }).toList();
}
