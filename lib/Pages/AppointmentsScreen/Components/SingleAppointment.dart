import 'dart:developer';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/Appointment.dart';
import 'package:besure_hcp/Pages/AppointmentsScreen/AppointmentDetails.dart';
import 'package:besure_hcp/Services/AppointmentServices.dart';
import 'package:besure_hcp/pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class SingleAppointment extends StatefulWidget {
  SingleAppointment({super.key, this.appointment});

  Appointment? appointment;

  @override
  State<SingleAppointment> createState() => _SingleAppointmentState();
}

class _SingleAppointmentState extends State<SingleAppointment> with Observer{
  DateTime? Newdate;

  String formatTime(String date){
    final String formattedTime = DateFormat('hh:mm a').format(DateTime.parse(date));
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        // width: 95.w,
        decoration: BoxDecoration(
          border: Border.all(
            color: azureishBlue
          ),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: azureishBlue
                  )
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.appointment!.client!.fullName!, style: TextStyle(fontSize: 16),),
                  Container(
                    width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 7.w : 12.w,
                    height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 7.w : 12.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                    child: Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 0.5.w : 0.5.w),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(300.0),
                          child:
                         widget.appointment!.client!.profile == null
                          ?
                          Image.asset("assets/images/esnadTakaful.png")
                          :
                          Image.network(swaggerImagesUrl + "Clients/" + widget.appointment!.client!.profile!,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                            return Icon(Icons.person);
                          },)
                                  )
                 )),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 20,),
                      SizedBox(width: 2,),
                      Text(formatDate(widget.appointment!.bookingDate!), style: TextStyle(fontSize: 13),)
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.watch_later_rounded, size: 20),
                      SizedBox(width: 2,),
                      Text(formatTime(widget.appointment!.bookingDate!), style: TextStyle(fontSize: 13),)
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.green, size: 14,),
                      SizedBox(width: 2,),
                      Text(AppLocalizations.of(context)!.confirmed, style: TextStyle(fontSize: 13),)
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                    // width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: silverLakeBlue
                    ),
                    child: GestureDetector(
                      onTap: () async{
                  final DateTime? pickedDate = await showDatePicker(
                              helpText: 'Date',
                              context: context,
                              initialDate: DateTime.parse(widget.appointment!.bookingDate!),
                              firstDate: DateTime(0001),
                              lastDate: DateTime(2024)
                                  .add(const Duration(days: 360)));
                          if (pickedDate != null) {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              setState(() {
                                Newdate = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                              log(Newdate!.toString());
                              UpdateBookingDate(widget. appointment!.id!,Newdate!.toIso8601String());

                              Observable.instance.notifyObservers([
                              "_AppointmentsScreenState",
                              ], notifyName : "update");
                            }
                          }
                      },
                      child: Text(AppLocalizations.of(context)!.updateDate, style: TextStyle(color: Colors.white),),
                    )
                ),   
                Container(
                  padding: EdgeInsets.all(10),
                    // width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: silverLakeBlue
                    ),
                    child: GestureDetector(
                      onTap: () async{
                        Navigator.push(context, MaterialPageRoute(builder: ((context) => AppointmentDetails(appointment: widget.appointment))));
                      },
                      child: Text(AppLocalizations.of(context)!.giveServices, style: TextStyle(color: Colors.white),),
                    )
                ),                     
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    setState(() {
      
    });
  }
}