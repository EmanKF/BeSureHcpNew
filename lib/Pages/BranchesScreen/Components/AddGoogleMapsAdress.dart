import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';


class AddGoogleMapsAddress extends StatefulWidget {
  const AddGoogleMapsAddress({super.key, this.lat, this.long});

  final double? lat,long;

  @override
  State<AddGoogleMapsAddress> createState() => _AddGoogleMapsAddressState();
}

class _AddGoogleMapsAddressState extends State<AddGoogleMapsAddress> {
  GoogleMapController? controller;
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  // MarkerId? selectedMarker;
  // LatLng startLocation = LatLng(27.6602292, 85.308027); 
  LatLng? markerPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.lat != null && widget.long != null){
      LatLng latLng = LatLng(widget.lat!, widget.long!);
      markerPosition = latLng;
      if(_markers.length>=1)
        {
          _markers.clear();
        }

      _onAddMarkerButtonPressed(latLng);
    }
  }
  
  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  Future<void> _popToPreviousScreen(BuildContext context) async {
    Navigator.pop(context, markerPosition);
  }

   void _onAddMarkerButtonPressed(LatLng latlang) {
// loadAddress(latlang);
      markerPosition = latlang;
    setState(() {
       _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId('d'),
        position: latlang,
        infoWindow: InfoWindow(
          title: 'mm',
        //  snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        await Future.delayed(const Duration(seconds: 1));
        _popToPreviousScreen(context);
        return true;
      },
     child: Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   foregroundColor: grey,
      // ),
      body: Stack(
        children: [
          GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: widget.lat != null && widget.long != null ? LatLng(markerPosition!.latitude, markerPosition!.longitude) : LatLng(24.774265, 46.738586),
                    zoom: 11.0,
                  ),
                  onTap: (LatLng latLng){
                     if(_markers.length>=1)
                      {
                        _markers.clear();
                      }

                    _onAddMarkerButtonPressed(latLng);
                    // setState(() {
                    //   markerPosition = latLng;
                    // });
                    // print(latLng.latitude.toString());
                    // print(latLng.longitude.toString());
                  },
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
              ),

          Positioned(
            top: 15,
            child: Row(
              children: [
                    SizedBox(
                      width: 2,
                    ),
                    Container(
                      
                      decoration: BoxDecoration(
                        color: silverLakeBlue,
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          await Future.delayed(const Duration(seconds: 1));
                          Navigator.pop(context, markerPosition);
                        }, 
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              child: Icon(Icons.arrow_back, color: Colors.white)),
                              SizedBox(
                                width: 2,
                              ),
                              Text(AppLocalizations.of(context)!.exit, 
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),)
                          ],
                        )),
                    ),
              ],
            ),
          )    
        ],
        alignment: Alignment.topLeft,
      ),
    )
    );
  }
}