class SubAreaService {
  List<dynamic> subAreaList;

  static List<String> subAreasList = [];

  SubAreaService(this.subAreaList) {
    subAreaList.forEach((element) {
      subAreasList.add(element["subarea_name"]);
    });
  }

  List<String> getSuggestions(String query) {
    List<String> matches = List<String>.empty();
    matches.addAll(subAreasList);

    matches.retainWhere((s) =>
        s.toLowerCase().startsWith(query.toLowerCase()) && matches.contains(s));

    return matches;
  }
}
