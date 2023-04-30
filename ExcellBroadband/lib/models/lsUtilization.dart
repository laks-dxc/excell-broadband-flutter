class LSUtilization {
  bool isError;
  int lastUpdated;
  List<dynamic> utilization;
  

  LSUtilization(
      {this.isError = false,
      this.lastUpdated,
      this.utilization,
      });

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['isError'] = isError;
    m['lastUpdated'] = lastUpdated;
    m['utilization'] = utilization;


    return m;
  }
}

// class LSUtilizationList {
//   List<LSUtilization> items;

//   LSUtilizationList() {
//     items = new List();
//   }

//   toJSONEncodable() {
//     return items.map((item) {
//       return item.toJSONEncodable();
//     }).toList();
//   }
// }
