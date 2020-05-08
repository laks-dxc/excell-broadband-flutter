import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = [
  'assets/slide1.png',
  'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
  // 'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
  // 'https://images.unsplash.com/photo-1586901533048-0e856dff2c0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  // 'https://images.unsplash.com/photo-1586902279476-3244d8d18285?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
];

class ConnectionsCarousel extends StatelessWidget {
  Widget carouselItem(litem, width) {
    return litem.toString().startsWith("assets")
        ? Image.asset(
            litem,
            fit: BoxFit.fill,
            width: width,
          )
        : Image.network(
            litem,
            fit: BoxFit.fill,
            width: width,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: false,
          viewportFraction: 1.0,
          aspectRatio: 2.0,
        ),
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
