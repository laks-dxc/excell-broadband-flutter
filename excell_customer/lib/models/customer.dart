import 'package:ExcellCustomer/helpers/netUtils.dart';
// import 'package:ExcellCustomer/helpers/netUtils.dev.dart';
// import 'package:ExcellCustomer/helpers/netUtils.dev.dart';

import 'package:ExcellCustomer/helpers/storageUtils.dart';
import 'package:ExcellCustomer/models/enum.dart';

class Customer {
  static Future<String> getInvoice(String invoiceNo) async {
    dynamic getInvoiceBody = {
      "name": "getPdfInvoice",
      "param": {
        "customerId": await StorageUtils.getStorageItem(StorageKey.CustId),
        "invoiceNo": invoiceNo
      }
    };

    // return await NetUtilsDev.apiPostWithTokenReturnPDF(getInvoiceBody);
    return await NetUtils.apiPostWithTokenReturnPDF(getInvoiceBody);
  }

  static Future<Map<String, dynamic>> getInvoices() async {
    dynamic getInvoiceBody = {
      "name": "getAllInvoices",
      "param": {
        "customerId": await StorageUtils.getStorageItem(StorageKey.CustId)
      }
    };

    // Map<String, dynamic> invoicesResponse = await NetUtilsDev.apiPostWithToken(getInvoiceBody);
    Map<String, dynamic> invoicesResponse =
        await NetUtils.apiPostWithToken(getInvoiceBody);

    return invoicesResponse;
  }

  static Future<Map<String, dynamic>> getReceipts() async {
    dynamic getReceiptBody = {
      "name": "getAllPayreceipts",
      "param": {
        "customerId": await StorageUtils.getStorageItem(StorageKey.CustId)
      }
    };
    Map<String, dynamic> invoicesResponse =
        await NetUtils.apiPostWithToken(getReceiptBody);

    // Map<String, dynamic> invoicesResponse = await NetUtilsDev.apiPostWithToken(getReceiptBody);
    return invoicesResponse;
  }

  static Future<List<dynamic>> getConnectionLogs(pkgnum) async {
    dynamic connectionDataLogsBody = {
      "name": "getConnectionDataLogs",
      "param": {
        "customerId": await StorageUtils.getStorageItem(StorageKey.CustId),
        "pkgnum": pkgnum
      }
    };
    Map<String, dynamic> connectionDataLogs =
        await NetUtils.apiPostWithToken(connectionDataLogsBody);
    // Map<String, dynamic> connectionDataLogs = await NetUtilsDev.apiPostWithToken(connectionDataLogsBody);
    if (connectionDataLogs["status"] == 200)
      return connectionDataLogs["result"]["connectiondatalogs"];
    else
      return [];
  }

  static Future<List> banners() async {
    Map<String, dynamic> cmsBannersResponse =
        await NetUtils.apiPostWithToken({"name": "getCMSBanners", "param": {}});

    if (cmsBannersResponse["status"] == 200)
      return cmsBannersResponse["result"]["banners"];
    else
      return [];
  }

  static Future<String> invoice(String invoiceNo) async {
    dynamic invoiceBody = {
      "name": "getPdfInvoice",
      "param": {
        "customerId": await StorageUtils.getStorageItem(StorageKey.CustId),
        "invoiceNo": invoiceNo
      }
    };

    Map<String, dynamic> pdfResponse =
        await NetUtils.apiPostWithToken(invoiceBody);

    if (pdfResponse["status"] == 200)
      return pdfResponse["result"]["filecontent"];
    else
      return "File Not Found";
  }

  static Future<Map<String, dynamic>> authenticate(
      String custId, String mobileNo) async {
    Map<String, dynamic> authenticatedResponse =
        await NetUtils.apiPostWithoutToken({
      "name": "generateToken",
      "param": {"custId": custId, "mobileNum": mobileNo, "mobilOTP": "1"}
    });

    Map<String, dynamic> authResponse = {
      "status": -1,
      "token": "",
      "otp": "otp"
    };

    if (authenticatedResponse["status"] == 200) {
      String token = authenticatedResponse["result"]["token"];

      authResponse = {
        "status": 200,
        "token": token,
        "otp": authenticatedResponse['result']['otp']
      };
      await StorageUtils.setStorageItem(StorageKey.UserToken, token);
    } else {}

    return authResponse;
  }

  static Future<Map<String, dynamic>> authenticateWithoutOTP(
      String custId, String mobileNo) async {
    Map<String, dynamic> authenticatedResponse =
        await NetUtils.apiPostWithoutToken({
      "name": "generateToken",
      "param": {"custId": custId, "mobileNum": mobileNo, "mobilOTP": "0"}
    });

    Map<String, dynamic> authResponse = {"status": -1, "token": ""};

    if (authenticatedResponse["status"] == 200) {
      String token = authenticatedResponse["result"]["token"];
      await StorageUtils.setStorageItem(StorageKey.UserToken, token);
      print("token " + token);

      authResponse = {"status": 200, "token": token};
    } else {}

    return authResponse;
  }

  static Future<bool> isLoggedIn() async {
    return await StorageUtils.hasKey(StorageKey.CutomerName);
  }

  static Future<void> saveFBToken(String custId, String mobileNo) async {
// http://app.excellbroadband.com/api/index.php

    dynamic body = {
      "name": "saveFBToken",
      "param": {
        "customerId": custId,
        "mobileNo": mobileNo,
        "fbToken": await StorageUtils.getStorageItem(StorageKey.FBToken),
        "appVersion": "1.0",
        "mobileOs": "Android"
      }
    };

    await NetUtils.apiPostWithToken(body);
    print("FBToken Saved");
  }

  static Future<bool> details(String custId, String mobileNo) async {
    Map<String, dynamic> customerDetailsResponse =
        await NetUtils.apiPostWithToken({
      "name": "getCustomerDetails",
      "param": {"customerId": custId}
    });

    bool detailsReceived;
    print("customerDetailsResponse " + customerDetailsResponse.toString());
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
    final Map<String, dynamic> ticketsListResponse =
        await NetUtils.apiPostWithToken({
      "name": "getCustTickets",
      "param": {
        "customerId": await StorageUtils.getStorageItem(StorageKey.CustId)
      }
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
    final Map<String, dynamic> ticketsListResponse =
        await NetUtils.apiPostWithToken({
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
    final Map<dynamic, dynamic> ticketCreatedtResponse =
        await NetUtils.apiPostWithToken({
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

    // final Map<String, dynamic> connectionsListResponse = await NetUtilsDev.apiPostWithToken({
    final Map<String, dynamic> connectionsListResponse =
        await NetUtils.apiPostWithToken({
      "name": "getConnectionsList",
      "param": {
        "customerId": await StorageUtils.getStorageItem(StorageKey.CustId)
      }
    });

    if (connectionsListResponse["status"] == 200) {
      connectionsList = connectionsListResponse["result"]["connections"];
    }

    return connectionsList;
  }

  static Future<List<dynamic>> topupList(pkgnum) async {
    List<dynamic> topupList;

    // final Map<String, dynamic> connectionsListResponse = await NetUtilsDev.apiPostWithToken({
    final Map<String, dynamic> connectionsListResponse =
        await NetUtils.apiPostWithToken({
      "name": "gettopupPackages",
      "param": {
        "customerId": await StorageUtils.getStorageItem(StorageKey.CustId),
        "pkgnum": pkgnum
      }
    });

    if (connectionsListResponse["status"] == 200) {
      topupList = connectionsListResponse["result"]["topuplist"];
    }

    return topupList;
  }

  static Future<dynamic> paymentDue() async {
    dynamic paymentDue;

    final Map<String, dynamic> paymentDueResponse =
        await NetUtils.apiPostWithToken({
      "name": "getCustomerDue",
      "param": {
        "customerId": await StorageUtils.getStorageItem(StorageKey.CustId)
      }
    });

    if (paymentDueResponse["status"] == 200) {
      paymentDue = paymentDueResponse["result"];
    }

    return paymentDue;
  }

  static Future<dynamic> paymentDueWithToken(
      String token, String custId) async {
    dynamic paymentDue;

    final Map<String, dynamic> paymentDueResponse =
        await NetUtils.apiPostWithToken({
      "name": "getCustomerDue",
      "param": {"customerId": custId}
    }, token: token);

    if (paymentDueResponse["status"] == 200) {
      paymentDue = paymentDueResponse["result"];
    }

    return paymentDue;
  }

  static Future<List<dynamic>> getSmartUtilData(ipAddr) async {
    // final Map<String, dynamic> utilizationResponse = await NetUtilsDev.apiPostWithToken({
    final Map<String, dynamic> utilizationResponse =
        await NetUtils.apiPostWithToken({
      "name": "getUsageReport",
      "param": {
        "customerId": await StorageUtils.getStorageItem(StorageKey.CustId),
        "ip": ipAddr
      }
    });

    // List<dynamic> a = ;

    print(utilizationResponse["result"]["usagereport"].toString());

    return utilizationResponse["result"]["usagereport"];
  }

  static Future<List<dynamic>> getBBPlans(String locationId) async {
    final Map<String, dynamic> bbPlanDetails =
        await NetUtils.apiPostWithoutToken({
      "name": "getBbplanDetails",
      "param": {"locationId": locationId}
    });

    return bbPlanDetails["result"]["plans"];
  }

  static Future<List<dynamic>> getLocations() async {
    dynamic getLocationsResponse;

    getLocationsResponse = await NetUtils.apiPostWithoutToken({
      "name": "getLocations",
      "param": {"locationId": "all"}
    });

    return getLocationsResponse["result"]["locations"];
  }

  static Future<int> createEnquiry(
      {String name,
      String mobile,
      String email,
      String address,
      int areaId,
      String city,
      int subAreaId,
      String purpose = ""}) async {
    dynamic enquiryCreateResponse;

    enquiryCreateResponse = await NetUtils.apiPostWithoutToken({
      "name": "addEnquiry",
      "param": {
        "name": name,
        "mobile": mobile,
        "email": email,
        "address": address,
        "city": city,
        "area_id": areaId,
        "sub_area_id": subAreaId,
        "purpose": purpose,
        "source": "App"
      }
    });

    return int.parse(enquiryCreateResponse["status"].toString());
  }

  static Future<int> createReferrel(
      {String name,
      String mobile,
      String email,
      String address,
      int areaId,
      String city,
      int subAreaId,
      String purpose = ""}) async {
    dynamic createReferrelResponse;

    createReferrelResponse = await NetUtils.apiPostWithoutToken({
      "name": "addEnquiry",
      "param": {
        "name": name,
        "mobile": mobile,
        "email": email,
        "address": address,
        "city": city,
        "area_id": areaId,
        "sub_area_id": subAreaId,
        "purpose": purpose,
        "source": "App",
        "referral": "12",
        "customerId": await StorageUtils.getStorageItem(StorageKey.CustId),
      }
    });

    return int.parse(createReferrelResponse["status"].toString());
  }
}
