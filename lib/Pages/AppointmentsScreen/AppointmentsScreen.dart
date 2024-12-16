import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Models/Appointment.dart';
import 'package:besure_hcp/Pages/AppointmentsScreen/Components/SingleAppointment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/Services/AppointmentServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> with Observer {
  List<Appointment> appointments = List.empty(growable: true);

  String formatDate(String date){
    final String formattedDate = DateFormat('d-M-yyyy').format(DateTime.parse(date));
    return formattedDate;
  }
  
  @override
  void initState() {
    Observable.instance.addObserver(this);
    super.initState();
    loadApis();
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  void loadApis() async{
    List<Appointment> a = List.empty(growable: true);
    a = await getAllAppointments();
    setState(() {
      appointments = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.appointments),
      ),
      body: SingleChildScrollView(
        child: appointments.isEmpty ?
        Container(
          height: 100.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Center(
                  child: CircularProgressIndicator(
                    color: silverLakeBlue,
                  ),
                ),
            ],
          ),
        )
        :
        Column(
          children: [
            for(Appointment a in appointments)
            SingleAppointment(appointment: a)
          ],
        ),
      ),
    );
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    loadApis();
    setState(() {
      
    });
  }
}