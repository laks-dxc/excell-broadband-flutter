import 'package:ExcellCustomer/helpers/netUtils.dart';
import 'package:ExcellCustomer/helpers/storageUtils.dart';
import 'package:ExcellCustomer/models/enum.dart';

class Customer {
  static Future<Map<String, dynamic>> authenticate(String custId, String mobileNo) async {
    Map<String, dynamic> authenticatedResponse = await NetUtils.apiPostWithoutToken({
      "name": "generateToken",
      "param": {"custId": custId, "mobileNum": mobileNo, "mobilOTP": "1"}
    });

    Map<String, dynamic> authResponse = {"status": -1, "token": "", "otp": "otp"};

    if (authenticatedResponse["status"] == 200) {
      String token = authenticatedResponse["result"]["token"];

      authResponse = {"status": 200, "token": token, "otp": authenticatedResponse['result']['otp']};
      StorageUtils.setStorageItem(StorageKey.UserToken, token);
    } else {}

    return authResponse;
  }

  static Future<bool> isLoggedIn() async {
    return await StorageUtils.hasKey(StorageKey.UserToken);
  }

  static Future<bool> details(String custId, String mobileNo) async {
    Map<String, dynamic> customerDetailsResponse = await NetUtils.apiPostWithToken({
      "name": "getCustomerDetails",
      "param": {"customerId": custId}
    });

    bool detailsReceived;

    if (customerDetailsResponse["status"] == 200) {
      Map<String, dynamic> custDetails = customerDetailsResponse["result"];

      Map<StorageKey, String> storageItems = {
        StorageKey.CustId: custId,
        StorageKey.MobileNo: mobileNo,
        StorageKey.CutomerName: custDetails['cutomerName'],
        StorageKey.ContactNo: custDetails['contactno'],
        StorageKey.AltContactNo: custDetails['altcontactno'],
        StorageKey.Address: custDetails['address'],
        StorageKey.City: custDetails['city'],
        StorageKey.State: custDetails['state'],
        StorageKey.Emailid: custDetails['emailid'],
      };

      StorageUtils.setStorageItems(storageItems);

      detailsReceived = true;
    } else {
      detailsReceived = false;
    }

    return detailsReceived;
  }

  static Future<Map<String, dynamic>> ticketsList() async {
    final Map<String, dynamic> ticketsListResponse = await NetUtils.apiPostWithToken({
      "name": "getCustTickets",
      "param": {"customerId": await StorageUtils.getStorageItem(StorageKey.CustId)}
    });

    Map<String, dynamic> tickets;

    if (ticketsListResponse["status"] == 200) {
      List<dynamic> ticketList = ticketsListResponse["result"]["tickets"];
      int ticketCount = ticketList.length;
      tickets = {"ticketCount": ticketCount, "ticketsList": ticketList};
    } else {
      tickets = {"ticketCount": -1, "ticketsList": []};
    }

    return tickets;
  }

  static Future<Map<String, dynamic>> issueTypes() async {
    final Map<String, dynamic> ticketsListResponse = await NetUtils.apiPostWithToken({
      "name": "getIssueTypes",
      "param": {"issues": "all"}
    });

    Map<String, dynamic> issueTypes;

    if (ticketsListResponse["status"] == 200) {
      List<dynamic> issueTypeList = ticketsListResponse["result"]["issuetypes"];

      issueTypes = {"issueTypes": issueTypeList};
    } else {
      issueTypes = {"issueTypes": []};
    }

    return issueTypes;
  }

  static Future<int> createTicket(int issueTypeId, String issueTypeDesc) async {
    final Map<dynamic, dynamic> ticketCreatedtResponse = await NetUtils.apiPostWithToken({
      "name": "addCustTicket",
      "param": {
        "customerId": await StorageUtils.getStorageItem(StorageKey.CustId),
        "messageId": issueTypeId.toString(),
        "message": issueTypeDesc
      }
    });
    return ticketCreatedtResponse["status"];
  }

  static Future<List<dynamic>> connectionsList() async {
    List<dynamic> connectionsList;
    final Map<String, dynamic> connectionsListResponse = await NetUtils.apiPostWithToken({
      "name": "getConnectionsList",
      "param": {"customerId": await StorageUtils.getStorageItem(StorageKey.CustId)}
    });

    if (connectionsListResponse["status"] == 200) {
      connectionsList = connectionsListResponse["result"]["connections"];
    }

 
    return connectionsList;
  }

  static Future<List<dynamic>> getSmartUtilData(ipAddr) async {

    final Map<String, dynamic> utilizationResponse = await NetUtils.apiPostWithToken({
      "name": "getUsageReport",
      "param": {"customerId": await StorageUtils.getStorageItem(StorageKey.CustId), "ip": ipAddr}
    });

   
    // List<dynamic> a = ;

    return utilizationResponse["result"]["usagereport"];
  }


}
