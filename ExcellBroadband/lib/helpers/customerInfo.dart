import 'package:ExcellBroadband/helpers/utilities.dart';

class CustomerInfo {

  static Future<Map<String, dynamic>> connectionsList() async {
    final Map<String, dynamic> connectionsList = await Utilities.apiPost({
      "name": "getConnectionsList",
      "param": {"customerId": Utilities.getStorageItem('custId')}
    }, needAuth: true);

    return connectionsList;
  }


}
