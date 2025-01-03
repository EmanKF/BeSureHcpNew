import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Models/ReconcilationObject.dart';
import 'package:besure_hcp/Pages/ReconcilationReport/Components/SingleReconcilationRecord.dart';
import 'package:besure_hcp/Services/ReconcilationReportsServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:sizer/sizer.dart';

class PreReconcilationScreen extends StatefulWidget {
  const PreReconcilationScreen({super.key});

  @override
  State<PreReconcilationScreen> createState() => _PreReconcilationScreenState();
}

class _PreReconcilationScreenState extends State<PreReconcilationScreen> with Observer {
  List<ReconcilationObject> reconcilationList = List.empty(growable: true);
  bool isLoading = false;
  
  @override
  void initState() {
    Observable.instance.addObserver(this);
    super.initState();
    loadApi();
  }

  @override
  void dispose(){
  //   final webSocketService = ref.read(websocketProvider);
  //  webSocketService.dispose(ref);
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  void loadApi() async{
    setState(() {
      isLoading = true;
    });
    List<ReconcilationObject> rec = await GetAllReconcilation();
    setState(() {
      reconcilationList = rec;
      isLoading = false;
    }); 
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reconcilationReport, style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey.shade600)),
      ),
      body: isLoading == true?
      Container(
        height: 100.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(
                color: silverLakeBlue,
              ),
            )
          ],
        ),
      )
      :
       Column(
        children: [
          Row(
            children: [
              SizedBox(width: 10), 
              Icon(Icons.square, color: Colors.blue.shade300,),
              Text(AppLocalizations.of(context)!.pending),
              SizedBox(width: 20),
              Icon(Icons.square, color: Colors.green.shade300,),
              Text(AppLocalizations.of(context)!.completed),
              SizedBox(width: 20),
              Icon(Icons.square, color: Colors.red.shade300,),
              Text(AppLocalizations.of(context)!.rejected),
            ],
          ),
          for(ReconcilationObject r in reconcilationList)
          SingleReconcilationReport(reconcilation: r)
        ],
      ),
    );
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    loadApi();
  }
}