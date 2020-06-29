import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'animation/fadeIn.dart';
import 'helpers/Utils.dart';
import 'helpers/appStyles.dart';
import 'helpers/storageUtils.dart';
import 'models/AppTheme.dart';
import 'models/customer.dart';
import 'models/enum.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  String customerName = " ";
  Size displaySize;
  double textScaleFactor;
  List<String> imgList = [];

  @override
  void initState() {
    Customer.banners().then((_banners) {
      List<dynamic> tempImgLstObj = [];
      List<String> _tempImgLst = [];

      tempImgLstObj = _banners;
      print("tempImgLstObj.length " + tempImgLstObj.length.toString());
      if (tempImgLstObj.length > 0) {
        tempImgLstObj.forEach((element) {
          if (element["banner_image_path"] != null) _tempImgLst.add(element["banner_image_path"]);
        });

        if (_tempImgLst.length > 0) _tempImgLst.insert(0, 'assets/slide1.png');
      }
      setState(() {
        imgList = _tempImgLst;
      });
    });

    StorageUtils.getStorageItem(StorageKey.CutomerName).then((_customerName) {
      setState(() {
        customerName = _customerName;
      });
    });

    super.initState();
  }

  Widget carouselItem(litem, {width}) {
    return litem.toString().startsWith("assets")
        ? Image.asset(
            litem,
            fit: BoxFit.cover,
            // width: width,
          )
        : CachedNetworkImage(
            imageUrl: litem,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                child: Container(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(value: downloadProgress.progress))),
            errorWidget: (context, url, error) => Icon(Icons.error),
          );

    // : Image.network(
    //     litem,
    //     fit: BoxFit.cover,
    //     // width: width,
    //   );
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    textScaleFactor = MediaQuery.of(context).textScaleFactor == 1.0
        ? 1.0
        : 0.85 / MediaQuery.of(context).textScaleFactor;

    return ListView(
      children: <Widget>[
        FadeIn(
          Padding(
            padding: EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              "Welcome,",
              style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 24 * textScaleFactor),
            ),
          ),
          0.5,
          direction: Direction.y,
          distance: 10.0,
        ),
        FadeIn(
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              Utils.clipStringTo(customerName, 24, overflowWith: " "),
              style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 30 * textScaleFactor),
            ),
          ),
          0.7,
          direction: Direction.y,
          distance: -10.0,
        ),
        SizedBox(height: 20),
        imgList.length == 0
            ? FadeIn(Image.asset("assets/slide1.png"), 1.2, translate: false)
            : CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  aspectRatio: 2.0,
                  autoPlay: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 500),
                  disableCenter: true,
                  enableInfiniteScroll: true,
                ),
                items: imgList.map((item) => Container(child: carouselItem(item))).toList(),
              ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: tileContainer(
              image: Image.asset('assets/22.png'),
              title: "Payments",
              subTitle:
                  "Make your bill payments easily using \n Credit, Debit, Wallet & UPI options."),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
          child: tileContainer(
              image: Image.asset('assets/33.png'),
              title: "Utilization",
              subTitle:
                  "Be on top of your internet utilization \n and monitor your daily consumption."),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
          child: tileContainer(
              image: Image.asset(
                'assets/11.png',
                // color: Colors.white,
              ),
              title: "Support",
              subTitle: "Reach our support team for any \n connection or billing related issues."),
        )
      ],
    );
  }

  Widget tileContainer({Image image, title, subTitle}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: selectedTheme.activeBackground.withOpacity(0.5),
          border: Border.all(width: 0.35, color: selectedTheme.primaryColor)),
      height: displaySize.height * 0.12,
      width: displaySize.width,
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              ),
              color: selectedTheme.primaryColor,
            ),
            width: displaySize.width * 0.25,
            height: displaySize.height * 0.12,
            child: image,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 24 * textScaleFactor,
                      color: selectedTheme.primaryColor,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  subTitle,
                  maxLines: 3,
                  style: TextStyle(fontSize: 16 * textScaleFactor),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
