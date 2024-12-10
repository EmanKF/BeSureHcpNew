import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Models/Service.dart';
import 'package:besure_hcp/Pages/ServicesProvidedScreen/Components/ServiceProvidedWidget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../HomeScreen/Components/ServiceWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllServicesScreen extends StatefulWidget {
  const AllServicesScreen({super.key});
  static List<ServiceModel> allServices = [];
  static List<ServiceModel> allApprovedServices = [];
  @override
  State<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        title: Text(AppLocalizations.of(context)!.allServices),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        width: 100.w,
        height: 100.h,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for(ServiceModel service in AllServicesScreen.allApprovedServices)
              ServiceProvidedWidget(service: service, isHome: true)
            ],
          ),
        ),
      ),
    );
  }
}
