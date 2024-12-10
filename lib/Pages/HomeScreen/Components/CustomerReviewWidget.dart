import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Models/CustomerReview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

class CustomerReviewWidget extends StatelessWidget {
  const CustomerReviewWidget({super.key, this.customerReview});

  final CustomerReview? customerReview;

  @override
  Widget build(BuildContext context) {
    return Container(
       margin: EdgeInsets.all(MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 1.w : 2.w),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 1.w : 3.w),
        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 80.w: 90.w,
        decoration: BoxDecoration(
            color: lightBlue, borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.w : 2.w,
              ),
              Container(
                width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 4.w : 12.w,
                height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 4.w : 12.w,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(300.0),
                    child:
                    //  customerReview!.imageUrl!.contains('.')
                    //     ?
                         Image.asset("assets/images/esnadTakaful.png")
                        // : Image.network(customerReview!.imageUrl!)
                  ),
              ),
              Column(
                children: [
                 
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.w : 3.w,
                      ),
                      Container(
                        width: 65.w,
                        child: RatingBarIndicator(
                          rating: double.parse(customerReview!.ratingNb!.toString()),
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: darkPastelPurple,
                          ),
                          unratedColor: Colors.transparent,
                          itemCount: 5,
                          itemSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 1.5.w : 4.5.w,
                          direction: Axis.horizontal,
                        ),
                      ),
                    ],
                  ),
                  

              Row(
                children: [
                  SizedBox(
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.w : 3.w,
                      ),

                  Container(
                    width: 65.w,
                    child: Text(' '+
                      customerReview!.feedback!,
                      maxLines: 5,
                      // textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 3.sp : 8.sp),
                    ),
                  ),
                ],
              ),
                ],
              )
            ],
          ),
        
        ],
      ),
    );
  }
}
