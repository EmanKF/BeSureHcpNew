import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Pages/ManageAccountsScreen/EditEmployeeProfile.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/ServiceProvider.dart';
import 'package:besure_hcp/Pages/ManageAccountsScreen/ManageAccountsScreen.dart';
import 'package:besure_hcp/Services/ServiceProviderUserServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';


class SPUserWidget extends StatefulWidget {
  const SPUserWidget({super.key, this.spUser});

  final ServiceProvider? spUser;

  @override
  State<SPUserWidget> createState() => _SPUserWidgetState();
}

class _SPUserWidgetState extends State<SPUserWidget> {
      
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => EditEmployeeProfile(spUser: widget.spUser)));
      },
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          width: 100.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 5.w,
              ),
              Container(
                width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 4.w : 15.w,
                height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 4.w : 15.w,
                child: ClipRRect(
                  child: widget.spUser!.profile! == '' || widget.spUser!.profile!.contains('/') ? 
                  Image.asset('assets/images/avatar.jpg', fit: BoxFit.cover,)
                  :
                  Image.network(swaggerImagesUrl + "serviceproviderprofiles/"+widget.spUser!.profile!, fit: BoxFit.cover, errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                            return Icon(Icons.person);
                          },),
                  borderRadius: BorderRadius.circular(300),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 1.w : 3.w,
              ),
              Container(
                width: 60.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text(widget.spUser!.name!, textAlign: TextAlign.start, style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 13.sp : 17.sp, 
                          fontWeight: FontWeight.w700)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(widget.spUser!.email!, textAlign: TextAlign.start, style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 12.sp : 16.sp))
                      ],
                    ),
                    Row(
                      children: [
                        Text(widget.spUser!.mobileNb!, textAlign: TextAlign.start, style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 12.sp : 15.sp)),
                      ],
                    )
                  ],
                ),
              ),
              Spacer(),
             
               
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: InkWell(
                  onTap: () async{
                    print(widget.spUser!.id!);
                    bool res = await deleteSPUser(widget.spUser!.id!);
                    if(res == true){
                      ManageAccountsScreen.sPUsers.remove(widget.spUser);
                       Observable.instance.notifyObservers([
                        "_ManageAccountsScreenState",
                        ], notifyName : "update");
                      showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.userDeletedSuccessfully));
                    }
                    else{
                      showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.failedToDeleteUser));
                    }
                  }, 
                  child: Icon(Icons.delete, color: grey, size: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.w : 5.w)
                ),
              ),
      
            ],
          ),
      ),
    );
  }
}