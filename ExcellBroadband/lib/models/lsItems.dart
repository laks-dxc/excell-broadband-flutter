class LSItem {
  String token;
  String custId;
  String mobileNo;
  String custName;
  String cutomerName;
  String contactno;
  String altcontactno;
  String address;
  String city;
  String state;
  String emailid;

  LSItem(
      {this.token,
      this.custId,
      this.mobileNo,
      this.custName,
      this.cutomerName,
      this.contactno,
      this.altcontactno,
      this.address,
      this.city,
      this.state,
      this.emailid});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['token'] = token;
    m['custId'] = custId;
    m['mobileNo'] = mobileNo;
    m['custName'] = custName;
    m['cutomerName'] = cutomerName;
    m['contactno'] = contactno;
    m['altcontactno'] = altcontactno;
    m['address'] = address;
    m['city'] = city;
    m['state'] = state;
    m['emailid'] = emailid;

    return m;
  }
}

class LSItemList {
  List<LSItem> items;

  LSItemList() {
    items = new List<LSItem>.empty();
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}
