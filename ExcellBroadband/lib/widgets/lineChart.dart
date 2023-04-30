import 'package:ExcellBroadband/helpers/constants.dart';
import 'package:ExcellBroadband/helpers/fadeInY.dart';
import 'package:ExcellBroadband/helpers/utilities.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UtilLineChart extends StatefulWidget {
  final String ipAddr;

  UtilLineChart(this.ipAddr);

  @override
  _UtilLineChartState createState() => _UtilLineChartState(ipAddr);
}

class _UtilLineChartState extends State<UtilLineChart> {
  String ipAddr;
  List<dynamic> results;
  double maxY;

  _UtilLineChartState(this.ipAddr);

  void initState() {
    _getDataRow();
    super.initState();
  }

  List<Color> gradientColors = Constants.colors['gradient_colors3'];

  // [
  //   const Color(0xff23b6e6),
  //   const Color(0xff02d39a),
  // ];

  bool showAvg = false;

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
        color: Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: myBoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.only(
                  // right: 18.0, left: 12.0, top: 0, bottom: 12),
                  right: 0.0,
                  left: 0.0,
                  top: 0,
                  bottom: 0
                  
                  ),
              child: results != null && results.length > 0
                  ? FadeInY(
                      0.1,
                      LineChart(
                        mainData(results),
                      ),
                      translate: false,
                    )
                  : Container(child: Center(child: Text("No Data")),),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: FlatButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                  fontSize: 12,
                  color:
                      showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(_results) {
    return LineChartData(
      
      clipData: FlClipData.horizontal(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 0,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      minX: 1,
      maxX: double.parse(_results.length.toString()),
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
      
          spots: List.generate(_results.length, (index) => _results[index]),
          isCurved: true,
          colors: [
            const Color(0xff23b6e6),
            const Color(0xff02d39a),
          ],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 21,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
            FlSpot(11, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
            FlSpot(11, 3.44),
            FlSpot(11, 3.44),
            FlSpot(11, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.5),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }

  _getDataRow() async {
    List<dynamic> usageReport = await Utilities.getSmartUtilData(ipAddr);
    List<FlSpot> flSpots = [];
    double _maxY = 0;
    usageReport.forEach((element) {
      double y = double.parse(element["total"]);
      _maxY = _maxY > y ? _maxY : y;
      flSpots.add(
          FlSpot(double.parse(element["date"].toString().substring(8)), y));
    });

    setState(() {
      results = flSpots;
      maxY = _maxY + 1000;
      // print(results.toString());
    });
  }
}

/* Spots
// [
//   FlSpot(1, 22),
//   FlSpot(2, 9),
//   FlSpot(3, 23),
//   FlSpot(4, 3),
//   FlSpot(5, 28),
//   FlSpot(6, 31),
//   FlSpot(7, 17),
//   FlSpot(8, 22),
//   FlSpot(9, 5),

//   // FlSpot(10, 41),
//   // FlSpot(11, 36),
//   // FlSpot(12, 39),
//   // FlSpot(13, 21),
//   // FlSpot(14, 18),
//   // FlSpot(15, 23),
//   // FlSpot(16, 26),
//   // FlSpot(17, 5),
//   // FlSpot(18, 23),
//   // FlSpot(19, 8),
//   // FlSpot(20, 37),
//   // FlSpot(21, 14),
//   // FlSpot(22, 28),
//   // FlSpot(23, 41),
//   // FlSpot(24, 20),
//   // FlSpot(25, 41),
//   // FlSpot(26, 6),
//   // FlSpot(27, 43),
//   // FlSpot(28, 14),
//   // FlSpot(29, 28),
//   // FlSpot(30, 19),
//   // FlSpot(31, 9),
// ],
*/
