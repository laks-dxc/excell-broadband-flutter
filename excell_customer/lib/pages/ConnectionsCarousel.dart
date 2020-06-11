import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

List<String> imgList = [
  'assets/slide1.png',
  // 'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
  // 'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
  // 'https://images.unsplash.com/photo-1586901533048-0e856dff2c0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  // 'https://images.unsplash.com/photo-1586902279476-3244d8d18285?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
];

class ConnectionsCarousel extends StatelessWidget {
  ConnectionsCarousel(List<String> _imgList) {
    imgList = _imgList.length == 0
        ? imgList = [
            'assets/slide1.png',
          ]
        : imgList;
        
    imgList.addAll(_imgList);
  }
  // 'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',

  Widget carouselItem(litem, width) {
    return litem.toString().startsWith("assets")
        ? Image.asset(
            litem,
            fit: BoxFit.cover,
            // width: width,
          )
        : Image.network(
            litem,
            fit: BoxFit.cover,
            // width: width,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider(
        options: CarouselOptions(
            autoPlayInterval: Duration(seconds: 5),
            autoPlay: true,
            enlargeCenterPage: false,
            viewportFraction: 2.0,
            aspectRatio: 1.0,
            height: MediaQuery.of(context).size.height * 0.19),
        items: imgList
            .map((item) => Container(
                  child: Center(
                    child:
                        carouselItem(item, MediaQuery.of(context).size.width),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
