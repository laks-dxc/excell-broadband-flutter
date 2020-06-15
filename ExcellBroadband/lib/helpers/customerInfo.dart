import 'package:ExcellBroadband/helpers/utilities.dart';

class CustomerInfo {
  static Future<Map<String, dynamic>> connectionsList() async {
    final Map<String, dynamic> connectionsList = await Utilities.apiPost({
      "name": "getConnectionsList",
      "param": {"customerId": Utilities.getStorageItem('custId')}
    }, needAuth: true);

    return connectionsList;
  }

  static Future<Map<String, dynamic>> usageReport(String ipAddr) async {
    final Map<String, dynamic> connectionsList = await Utilities.apiPost({
      "name": "getUsageReport",
      "param": {"customerId": Utilities.getStorageItem('custId'), "ip": ipAddr}
    }, needAuth: true);

    return connectionsList;
  }

  static Future<List<dynamic>> getUtilData(_ipAddr) async {
    Map<String, dynamic> usageReportResponse =
        await CustomerInfo.usageReport(_ipAddr);

    List<dynamic> usageReport = [];

    if (Utilities.getStatus(usageReportResponse) == 200) {
      usageReport = usageReportResponse["resonse"]["result"]["usagereport"];
    } else {
      usageReport = [
        {"Error": usageReportResponse}
      ];
    }
    return usageReport;
  }
}
