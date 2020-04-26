import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = [
  'assets/slide1.png',
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: carouselItem(item),
          ),
        ))
    .toList();

class ConnectionsCarousel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConnectionsCarouselState();
  }
}

imageItem(String item) {
  return item.startsWith('assets')
      ? Image.asset(item,fit: BoxFit.fill,)
      : Image.network(item, fit: BoxFit.cover, width: 1000.0);
}

carouselItem(item) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    child: imageItem(item),
  );
}

class _ConnectionsCarouselState extends State<ConnectionsCarousel> {
  int _current = 0;
  CodeHelpers codeHelpers = new CodeHelpers();

  @override
  void initState() {
    codeHelpers.getURLs().forEach((url) {
      setState(() {
        imgList.add(url);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.map((url) {
            int index = imgList.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Colors.white24 // fromRGBO(255, 255, 0, 0.9)
                      : Colors.white //fromRGBO(0, 0, 0, 0.4),
                  ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
