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

  static Future<Map<String, dynamic>> supportTickets() async {
    final Map<String, dynamic> ticketsList = await Utilities.apiPost({
      "name": "getCustTickets",
      "param": {"customerId": Utilities.getStorageItem('custId')}
    }, needAuth: true);
    // print(ticketsList.toString());
    return ticketsList;
  }

  static Future<List<dynamic>> issueTypes() async {
    final Map<String, dynamic> issueTypesListResponse =
        await Utilities.apiPost({
      "name": "getIssueTypes",
      "param": {"issues": "all"}
    }, needAuth: true);

    List<dynamic> issueTypes;

    if (Utilities.getStatus(issueTypesListResponse) == 200) {
      issueTypes = issueTypesListResponse["resonse"]["result"]["issuetypes"];
    } else {
      issueTypes = [
        {"Error": issueTypesListResponse}
      ];
    }

    return issueTypes;
  }

  static Future<Map<String, dynamic>> createTicket(
      int issueTypeId, String issueTypeDesc) async {
    final Map<String, dynamic> ticketCreatedtResponse =
        await Utilities.apiPost({
      "name": "addCustTicket",
      "param": {
        "customerId": Utilities.getStorageItem('custId'),
        "messageId": issueTypeId.toString(),
        "message": issueTypeDesc
      }
    }, needAuth: true);

    print(ticketCreatedtResponse.toString());

    return ticketCreatedtResponse;
  }

  static Future<dynamic> getCustomerDue() async {
    dynamic dueInfo;
    dynamic customerDueInfo = await Utilities.apiPost({
      "name": "getCustomerDue",
      "param": {
        "customerId": Utilities.getStorageItem('custId'),
      }
    }, needAuth: true);

    if (Utilities.getStatus(customerDueInfo) == 200) {
      dueInfo = customerDueInfo["resonse"]["result"];
    }

    return dueInfo;
  }
}
