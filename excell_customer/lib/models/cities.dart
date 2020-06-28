class CitiesService {
  List<dynamic> excellLocationsList;

  static List<String> citiesList = [];

  CitiesService(this.excellLocationsList) {
    excellLocationsList.forEach((element) {
      citiesList.add(element["location"]);
    });
  }

  List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(citiesList);

    matches
        .retainWhere((s) => s.toLowerCase().startsWith(query.toLowerCase()) && matches.contains(s));

    return matches;
  }
}
