class CitiesService {
  List<dynamic> excellLocationsList;

  static List<String> citiesList = [];

  CitiesService(this.excellLocationsList) {
    excellLocationsList.forEach((element) {
      citiesList.add(element["location"]);
    });
  }

  List<String> getSuggestions(String query) {
    List<String> matches = List<String>.empty();
    matches.addAll(citiesList);

    matches.retainWhere((s) =>
        s.toLowerCase().startsWith(query.toLowerCase()) && matches.contains(s));

    List<String> returnMatches = [];

    matches.forEach((element) {
      if (!returnMatches.contains(element)) returnMatches.add(element);
    });

    return returnMatches;
  }
}
