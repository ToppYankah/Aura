class AppCountry {
  final String name;
  final String code;
  final List<String> cities;

  AppCountry({
    required this.name,
    required this.code,
    this.cities = const [
      "Accra",
      "Kumasi",
      "Tema",
      "Koforidua",
      "Sunyani",
      "Yendi",
      "Cape Coast",
      "Takoradi",
      "Tema",
    ],
  });
}
